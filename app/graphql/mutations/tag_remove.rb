# frozen_string_literal: true

module Mutations
  # Mutation function for removing a tag
  class TagRemove < Mutations::BaseMutation
    description "Remove a user's tag from a course"

    argument :id, ID, required: true

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      current_user = context[:current_user]

      raise "Anonymous users can't remove tags" if current_user.blank?

      tag = Tag.find_by(id: id, user: current_user)
      course = tag.course

      if tag.destroy
        {
          course: course,
          errors: []
        }
      else
        {
          course: nil,
          errors: tag.errors.full_messages
        }
      end
    end
  end
end
