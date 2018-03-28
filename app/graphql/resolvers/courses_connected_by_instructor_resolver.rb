# frozen_string_literal: true

module Resolvers
  # Return a collection of courses taught by instructors connected to a given instructor
  class CoursesConnectedByInstructorResolver
    def call(_obj, args, _ctx)
      course_ids_taught_by_instructor = CourseInstructor.where(email: args[:email]).pluck(:course_id)

      instructor_emails =
        CourseInstructor
        .where(course_id: course_ids_taught_by_instructor)
        .where.not(email: args[:email])
        .distinct
        .pluck(:email)

      course_ids_taught_by_connected_instructors =
        CourseInstructor
        .where(email: instructor_emails)
        .distinct
        .pluck(:course_id)

      Course.where(id: course_ids_taught_by_connected_instructors)
    end
  end
end
