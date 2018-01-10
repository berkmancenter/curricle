# frozen_string_literal: true

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'Curricle queries'

  field :courses, !types[Types::CourseType] do
    description 'Queries that return lists of courses'

    argument :basic_keywords, types[types.String], 'List of keyword strings'
    argument :deluxe_keywords, types[Inputs::DeluxeKeywordInput], 'List of objects for a weighted, field-specific search'

    resolve Resolvers::CoursesResolver.new
  end
end
