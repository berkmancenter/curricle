# frozen_string_literal: true

module Mutations
  # Mutation function for adding or updating a course annotation
  class TagSet < Mutations::BaseMutation
    description 'Adds a tag'

    argument :name, String, required: true
    argument :course_id, ID, required: true

    field :tag, Types::TagType, null: true
    field :errors, [String], null: false

    def resolve(course_id:, name:)
      current_user = context[:current_user]

      # TODO: find a more elegant way of handling mutation requests from anonymous users
      raise "Anonymous users can't add tags" if current_user.blank?

      tag = Tag.new(name: name, course_id: course_id, user: current_user)

      if tag.save
        {
          tag: tag,
          errors: []
        }
      else
        {
          tag: nil,
          errors: tag.errors.full_messages
        }
      end
    end
  end
end
