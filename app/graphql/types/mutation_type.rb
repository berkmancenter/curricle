# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :annotationSet, function: Mutations::AnnotationSet.new
  field :tagRemove, function: Mutations::TagRemove.new
  field :tagSet, function: Mutations::TagSet.new
  field :userCourseRemove, function: Mutations::UserCourseRemove.new
  field :userCourseSet, function: Mutations::UserCourseSet.new
end
