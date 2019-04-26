# frozen_string_literal: true

module Types
  class UserCourseType < Types::BaseObject
    description 'Course that a user has selected'

    field :course, Types::CourseType, null: false
    field :created_at, String, null: false
    field :id, ID, null: false
    field :include_in_path, Boolean, null: false
    field :updated_at, String, null: false
  end
end
