# frozen_string_literal: true

module Resolvers
  # Return a collection of courses taught by instructors connected to a given instructor
  class CoursesConnectedByInstructor < Resolvers::Base
    MAX_CO_INSTRUCTORS = 8

    COURSE_TITLE_BLACKLIST = [
      'Directed Study',
      'Directed Writing',
      'Direction of Doctoral Dissertation',
      'Direction of Doctoral Dissertations',
      "Direction of Master's Thesis",
      'Dissertation',
      'Foreign Language Certification',
      'Graduate Proseminar',
      'Guided Research',
      'Independent Study',
      'Individual Reading and Research',
      'Individual Reading Tutorial',
      'Individual Research',
      'Non-Resident Research',
      'Preparation for General Examinations',
      'Preparation for the Topical Examination',
      'Reading and Research',
      'Reading or Topics Course',
      'Research',
      'Senior Thesis Workshop',
      'Special Examinations Direction',
      'Special Reading and Research',
      'Supervised Reading and Research',
      'Thesis Research and Writing',
      'Tutorial - Senior Year'
    ].freeze

    type [Types::CourseType], null: false

    argument :course_levels, [Types::Enums::CourseLevel], required: false
    argument :name, String, "Instructor's name", required: true
    argument :semester, Types::Inputs::Semester, required: true

    def resolve(course_levels:, name:, semester:)
      instructor_name = name
      term_name = semester[:term_name]
      term_year_range = determine_term_year_range(semester)

      search_results = search_for_instructor(instructor_name, term_year_range).results

      return Course.none if search_results.blank?

      instructor_email = search_results.first.email

      course_ids_taught_by_instructor = search_results.map(&:course_id).compact

      query_co_taught_courses(course_ids_taught_by_instructor, instructor_email, term_name, term_year_range, course_levels)
    end

    private

    def determine_term_year_range(semester)
      term_year_max = semester[:term_year]
      term_year_min = term_year_max - 10

      term_year_min..term_year_max
    end

    def search_for_instructor(instructor_name, term_year_range)
      CourseInstructor.search do
        fulltext instructor_name
        with(:term_year, term_year_range)
      end
    end

    def query_co_taught_courses(course_ids_taught_by_instructor, instructor_email, term_name, term_year_range, course_levels)
      instructor_emails = query_connected_instructor_emails(course_ids_taught_by_instructor, instructor_email, term_year_range)

      course_ids_taught_by_connected_instructors =
        CourseInstructor
        .where(email: instructor_emails)
        .where(term_name: term_name)
        .where(term_year: term_year_range.max)
        .distinct
        .pluck(:course_id)
        .compact

      return Course.none if course_ids_taught_by_connected_instructors.blank?

      filtered_course_ids = filter_course_ids_by_counts(course_ids_taught_by_connected_instructors)

      Course.search do
        with :crse_attr_value, Array(course_levels)
        with :id, filtered_course_ids
        without :title_sortable, COURSE_TITLE_BLACKLIST
        paginate page: 1, per_page: 30
      end.results
    end

    def query_connected_instructor_emails(course_ids, instructor_email, term_year_range)
      CourseInstructor
        .where(course_id: course_ids)
        .where(term_year: term_year_range)
        .where.not(email: instructor_email)
        .distinct
        .pluck(:email)
    end

    # Eliminate 'noise' in results by filtering out courses with more than a given number of instructors
    def filter_course_ids_by_counts(course_ids)
      course_id_counts = CourseInstructor.where(course_id: course_ids).group(:course_id).count

      course_id_counts.select { |_k, v| v <= MAX_CO_INSTRUCTORS }.keys
    end
  end
end
