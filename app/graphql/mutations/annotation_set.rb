# frozen_string_literal: true

module Mutations
  # Mutation function for adding or updating a course annotation
  class AnnotationSet < GraphQL::Function
    description 'Adds or updates an annotation'

    type Types::AnnotationType

    argument :id, types.ID, 'Annotation ID'
    argument :text, !types.String, 'Annotation text'
    argument :course_id, !types.ID, 'ID of course to be annotated'

    def call(_obj, args, context)
      current_user = context[:current_user]

      # TODO: find a more elegant way of handling mutation requests from anonymous users
      raise "Anonymous users can't add annotations" if current_user.blank?

      annotation = Annotation.find_or_initialize_by(id: args[:id], course_id: args[:course_id], user: current_user)
      annotation.text = args[:text]
      annotation.save!
      annotation
    end
  end
end
