# frozen_string_literal: true

module Resolvers
  # Return a collection of courses taught by instructors connected to a given instructor
  class CoursesConnectedByInstructor
    START_YEAR_TERM_SCOPE = {
      'Spring' => %w[Spring Summer Fall],
      'Summer' => %w[Summer Fall],
      'Fall' => %w[Fall]
    }.freeze

    END_YEAR_TERM_SCOPE = {
      'Spring' => %w[Spring],
      'Summer' => %w[Spring Summer],
      'Fall' => %w[Spring Summer Fall]
    }.freeze

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

    def self.run(course_levels:, name:, semester_range:)
      search_results = search_for_instructor(name, semester_range).results

      return Course.none if search_results.blank?

      instructor_email = search_results.first.email
      course_ids_taught_by_instructor = search_results.map(&:course_id).compact
      instructor_emails = query_connected_instructor_emails(course_ids_taught_by_instructor, instructor_email)
      course_ids = search_connected_instructor_course_ids(instructor_emails, semester_range)
      filtered_course_ids = filter_course_ids_by_counts(course_ids)

      query_co_taught_courses(course_levels, filtered_course_ids)
    end

    def self.search_for_instructor(name, semester_range)
      term_year = semester_range.dig(:end, :term_year) || semester_range.dig(:start, :term_year)

      CourseInstructor.search do
        fulltext name
        with(:term_year, (term_year - 10)..term_year)
        paginate page: 1, per_page: 9999
      end
    end

    def self.query_co_taught_courses(course_levels, filtered_course_ids)
      return Course.none if filtered_course_ids.blank?

      Course.search do
        with :crse_attr_value, course_levels if course_levels.any?
        with :id, filtered_course_ids
        without :title, nil
        without :title_sortable, COURSE_TITLE_BLACKLIST
        paginate page: 1, per_page: 9999
        order_by(:external_course_id)
      end.results
    end

    def self.query_connected_instructor_emails(course_ids, instructor_email)
      CourseInstructor
        .where(course_id: course_ids)
        .where.not(email: ['', instructor_email])
        .distinct
        .pluck(:email)
    end

    def self.search_connected_instructor_course_ids(instructor_emails, semester_range)
      CourseInstructor
        .search do
          with :email, instructor_emails
          filter_by_semester_range(self, semester_range[:start], semester_range[:end])
          paginate page: 1, per_page: 9999
        end
        .results
        .pluck(:course_id)
        .uniq
    end

    # Eliminate 'noise' in results by filtering out courses with more than a given number of instructors
    def self.filter_course_ids_by_counts(course_ids)
      course_id_counts = CourseInstructor.where(course_id: course_ids).group(:course_id).count

      course_id_counts.select { |_k, count| count <= MAX_CO_INSTRUCTORS }.keys
    end

    def self.filter_by_single_semester(sunspot, semester)
      sunspot.instance_eval do
        with(:term_name, semester[:term_name])
        with(:term_year, semester[:term_year])
      end
    end

    def self.filter_by_semester_range(sunspot, semester_range_start, semester_range_end)
      return filter_by_single_semester(sunspot, semester_range_start) if semester_range_end.blank?

      sunspot.instance_eval do
        any_of do
          # add semesters for start year
          all_of do
            with(:term_name, START_YEAR_TERM_SCOPE[semester_range_start.term_name])
            with(:term_year, semester_range_start.term_year)
          end

          # add semesters for end year
          all_of do
            with(:term_name, END_YEAR_TERM_SCOPE[semester_range_end.term_name])
            with(:term_year, semester_range_end.term_year)
          end

          # add all semesters for intermediate years
          intermediate_years = (semester_range_start.term_year..semester_range_end.term_year).to_a[1...-1]

          return unless intermediate_years.any?

          all_of do
            with :term_name, Types::Enums::TermName.values.values.map(&:value)
            with :term_year, intermediate_years
          end
        end
      end
    end
  end
end
