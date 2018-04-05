# frozen_string_literal: true

Types::CourseCountType = GraphQL::ObjectType.define do
  name 'CourseCountType'
  description 'Aggregate data about the number of courses'

  field :component, !types.String
  field :department, !types.String
  field :count, !types.Int
end
