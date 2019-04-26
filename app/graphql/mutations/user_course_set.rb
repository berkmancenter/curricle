# frozen_string_literal: true

module Mutations
  # Mutation function for adding or updating a user course selection
  class UserCourseSet < Mutations::BaseMutation
    description "Adds or updates a user's course selection"

    argument :course_id, ID, required: true
    argument :include_in_path, Boolean, required: true

    field :user_course, Types::UserCourseType, null: true
    field :errors, [String], null: false

    def resolve(course_id:, include_in_path:)
      current_user = context[:current_user]

      # TODO: find a more elegant way of handling mutation requests from anonymous users
      raise "Anonymous users can't add user courses" if current_user.blank?

      user_course = UserCourse.find_or_initialize_by(course_id: course_id, user: current_user)
      user_course.include_in_path = include_in_path

      if user_course.save
        {
          user_course: user_course,
          errors: []
        }
      else
        {
          user_course: nil,
          errors: user_course.errors.full_messages
        }
      end
    end
  end
end
