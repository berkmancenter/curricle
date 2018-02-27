# frozen_string_literal: true

module Mutations
  # Mutation function for removing a user course
  class UserCourseRemove < GraphQL::Function
    description "Removes a user's course selection"

    type types.ID

    argument :course_id, !types.ID

    def call(_obj, args, context)
      current_user = context[:current_user]

      raise "Anonymous users can't remove user courses" if current_user.blank?

      UserCourse.find_by(course_id: args[:course_id], user: current_user).destroy

      args[:course_id]
    end
  end
end
