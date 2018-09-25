# frozen_string_literal: true

Types::TagType = GraphQL::ObjectType.define do
  name 'Tag'
  description 'Tag added by a user for a course'

  field :course, !Types::CourseType, 'Associated course' do
    resolve ->(tag, _args, _ctx) { tag.course }
  end

  field :created_at, !types.String
  field :id, !types.ID
  field :name, !types.String
  field :updated_at, !types.String
end
