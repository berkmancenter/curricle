# frozen_string_literal: true

module Resolvers
  # Return a collection of courses taught by instructors connected to a given instructor
  class CoursesConnectedByInstructorResolver
    def call(_obj, args, _ctx)
      term_name = args[:semester][:term_name]
      term_year_max = args[:semester][:term_year]
      term_year_min = term_year_max - 2
      term_year_range = term_year_min..term_year_max

      search =
        CourseInstructor.search do
          fulltext args[:name]
          with(:term_year, term_year_range)
        end

      return Course.none if search.results.blank?

      instructor_email = search.results.first.email
      course_ids_taught_by_instructor = search.results.map(&:course_id)

      instructor_emails =
        CourseInstructor
        .where(course_id: course_ids_taught_by_instructor)
        .where(term_year: term_year_range)
        .where.not(email: instructor_email)
        .distinct
        .pluck(:email)

      course_ids_taught_by_connected_instructors =
        CourseInstructor
        .where(email: instructor_emails)
        .where(term_name: term_name)
        .where(term_year: term_year_max)
        .distinct
        .pluck(:course_id)

      Course.where(id: course_ids_taught_by_connected_instructors)
    end
  end
end
