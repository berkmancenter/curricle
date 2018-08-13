# frozen_string_literal: true

module Mutations
  # Mutation function for removing a tag
  class TagRemove < GraphQL::Function
    description "Remove a user's tag from a course"

    type Types::CourseType

    argument :id, !types.ID

    def call(_obj, args, context)
      current_user = context[:current_user]

      raise "Anonymous users can't remove tags" if current_user.blank?

      tag = Tag.find_by(id: args[:id], user: current_user)
      course = tag.course

      tag.destroy

      course
    end
  end
end
