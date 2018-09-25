# frozen_string_literal: true

module Mutations
  # Mutation function for adding or updating a course annotation
  class TagSet < GraphQL::Function
    description 'Adds a tag'

    type Types::TagType

    argument :name, !types.String
    argument :course_id, !types.ID

    def call(_obj, args, context)
      current_user = context[:current_user]

      # TODO: find a more elegant way of handling mutation requests from anonymous users
      raise "Anonymous users can't add tags" if current_user.blank?

      Tag.create!(name: args[:name], course_id: args[:course_id], user: current_user)
    end
  end
end
