# frozen_string_literal: true

module Resolvers
  # Return a collection of courses taught by instructors connected to a given instructor
  class CoursesConnectedByInstructorResolver
    MAX_CO_INSTRUCTORS = 8

    def call(_obj, args, _ctx)
      instructor_name = args[:name]
      term_name = args[:semester][:term_name]
      term_year_range = determine_term_year_range(args[:semester])

      search_results = search_for_instructor(instructor_name, term_year_range).results

      return Course.none if search_results.blank?

      instructor_email = search_results.first.email

      course_ids_taught_by_instructor = search_results.map(&:course_id)

      query_co_taught_courses(course_ids_taught_by_instructor, instructor_email, term_name, term_year_range)
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

    def query_co_taught_courses(course_ids_taught_by_instructor, instructor_email, term_name, term_year_range)
      instructor_emails = query_connected_instructor_emails(course_ids_taught_by_instructor, instructor_email, term_year_range)

      course_ids_taught_by_connected_instructors =
        CourseInstructor
        .where(email: instructor_emails)
        .where(term_name: term_name)
        .where(term_year: term_year_range.max)
        .pluck(:course_id)

      filtered_course_ids = filter_course_ids_by_counts(course_ids_taught_by_connected_instructors)

      Course.where(id: filtered_course_ids)
    end

    def query_connected_instructor_emails(course_ids, instructor_email, term_year_range)
      CourseInstructor
        .where(course_id: course_ids)
        .where(term_year: term_year_range)
        .where(instructor_role: %w[HEAD PI]) # eliminate TFs, course coordinators, etc.
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
