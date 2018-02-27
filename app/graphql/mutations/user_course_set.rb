# frozen_string_literal: true

module Mutations
  # Mutation function for adding or updating a user course selection
  class UserCourseSet < GraphQL::Function
    description "Adds or updates a user's course selection"

    type Types::UserCourseType

    argument :course_id, !types.ID
    argument :include_in_path, types.Boolean

    def call(_obj, args, context)
      current_user = context[:current_user]

      # TODO: find a more elegant way of handling mutation requests from anonymous users
      raise "Anonymous users can't add user courses" if current_user.blank?

      user_course = UserCourse.find_or_initialize_by(course_id: args[:course_id], user: current_user)
      user_course.include_in_path = args[:include_in_path]
      user_course.save!
      user_course
    end
  end
end
