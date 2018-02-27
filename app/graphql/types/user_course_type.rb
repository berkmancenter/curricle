# frozen_string_literal: true

Types::UserCourseType = GraphQL::ObjectType.define do
  name 'UserCourse'
  description 'Course that a user has selected'

  field :course, !Types::CourseType, 'Associated course' do
    resolve ->(user_course, _args, _ctx) { user_course.course }
  end

  field :created_at, !types.String
  field :id, !types.ID
  field :include_in_path, !types.Boolean
  field :updated_at, !types.String
end
