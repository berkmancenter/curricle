# frozen_string_literal: true

module Mutations
  # Mutation function for adding or updating a course annotation
  class AnnotationSet < Mutations::BaseMutation
    description 'Adds or updates an annotation'

    argument :course_id, ID, 'ID of course to be annotated', required: true
    argument :id, ID, required: false
    argument :text, String, required: true

    field :annotation, Types::AnnotationType, null: true
    field :errors, [String], null: false

    def resolve(course_id:, id:, text:)
      current_user = context[:current_user]

      # TODO: find a more elegant way of handling mutation requests from anonymous users
      raise "Anonymous users can't add annotations" if current_user.blank?

      annotation = Annotation.find_or_initialize_by(course_id: course_id, id: id, user: current_user)
      annotation.text = text

      if annotation.save
        {
          annotation: annotation,
          errors: []
        }
      else
        {
          annotation: nil,
          errors: annotation.errors.full_messages
        }
      end
    end
  end
end
