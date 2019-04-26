# frozen_string_literal: true

module Types
  class AnnotationType < Types::BaseObject
    description 'Annotation added by a user for a course'

    field :course, Types::CourseType, null: false
    field :created_at, String, null: false
    field :id, ID, null: false
    field :text, String, null: false
    field :updated_at, String, null: false
  end
end
