# frozen_string_literal: true

Types::CourseKeywordType = GraphQL::InputObjectType.define do
  name 'CourseKeyword'
  argument :keyword, !types.String
end
