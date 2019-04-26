# frozen_string_literal: true

module Types
  class TagType < Types::BaseObject
    description 'Tag added by a user for a course'

    field :course, Types::CourseType, null: false
    field :created_at, String, null: false
    field :id, ID, null: false
    field :name, String, null: false
    field :updated_at, String, null: false
  end
end
