# frozen_string_literal: true

module Types
  class CourseInstructorType < Types::BaseObject
    description 'Represents a course instructor in Curricle'

    def display_name
      "#{object.first_name} #{object.last_name}"
    end

    field :course, Types::CourseType, null: true
    field :created_at, String, null: false
    field :display_name, String, 'First and last name', null: true
    field :email, String, null: true
    field :first_name, String, null: true
    field :id, ID, null: false
    field :instructor_role, String, null: true
    field :last_name, String, null: true
    field :middle_name, String, null: true
    field :name_prefix, String, null: true
    field :name_suffix, String, null: true
    field :updated_at, String, null: false
  end
end
