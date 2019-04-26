# frozen_string_literal: true

module Mutations
  # Mutation function for removing a user course
  class UserCourseRemove < Mutations::BaseMutation
    description "Removes a user's course selection"

    argument :course_id, ID, required: true

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(course_id:)
      current_user = context[:current_user]

      raise "Anonymous users can't remove user courses" if current_user.blank?

      user_course = UserCourse.find_by(course_id: course_id, user: current_user)
      course = user_course.course

      if user_course.destroy
        {
          course: course,
          errors: []
        }
      else
        {
          course: nil,
          errors: user_course.errors.full_messages
        }
      end
    end
  end
end
