# frozen_string_literal: true

Types::AnnotationType = GraphQL::ObjectType.define do
  name 'Annotation'
  description 'Annotation added by a user for a course'

  field :course, !Types::CourseType, 'Associated course' do
    resolve ->(annotation, _args, _ctx) { annotation.course }
  end

  field :created_at, !types.String, 'Created at'
  field :id, !types.ID, 'ID'
  field :text, !types.String, 'Annotation text'
  field :updated_at, !types.String, 'Updated at'
end
