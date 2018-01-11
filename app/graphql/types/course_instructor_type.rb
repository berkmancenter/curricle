# frozen_string_literal: true

Types::CourseInstructorType = GraphQL::ObjectType.define do
  name 'CourseInstructor'
  description 'Represents a course instructor in Curricle'

  field :display_name, types.String, 'First and last name' do
    resolve ->(course_instructor, _args, _ctx) { "#{course_instructor.first_name} #{course_instructor.last_name}" }
  end
  field :email, types.String, 'Email address'
  field :first_name, types.String, 'First name'
  field :id, !types.ID, 'Unique ID'
  field :instructor_role, types.String, 'Role'
  field :last_name, types.String, 'Last name'
  field :middle_name, types.String, 'Middle name'
  field :name_prefix, types.String, 'Prefix for name'
  field :name_suffix, types.String, 'Suffix for name'
end
