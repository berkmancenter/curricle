# frozen_string_literal: true

module Resolvers
  # Return a collection of courses taught by instructors connected to a given instructor
  class CoursesConnectedByInstructorResolver
    def call(_obj, args, _ctx)
      term_year_limit = 2.years.ago.year

      course_ids_taught_by_instructor =
        CourseInstructor
        .where(email: args[:email])
        .where("term_year >= #{term_year_limit}")
        .pluck(:course_id)

      instructor_emails =
        CourseInstructor
        .where(course_id: course_ids_taught_by_instructor)
        .where("term_year >= #{term_year_limit}")
        .where.not(email: args[:email])
        .distinct
        .pluck(:email)

      course_ids_taught_by_connected_instructors =
        CourseInstructor
        .where(email: instructor_emails)
        .where("term_year >= #{term_year_limit}")
        .distinct
        .pluck(:course_id)

      Course.where(id: course_ids_taught_by_connected_instructors)
    end
  end
end
