# frozen_string_literal: true

class Types::Mutation < Types::BaseObject
  field :annotation_set, mutation: Mutations::AnnotationSet
  field :tag_remove, mutation: Mutations::TagRemove
  field :tag_set, mutation: Mutations::TagSet
  field :user_course_remove, mutation: Mutations::UserCourseRemove
  field :user_course_set, mutation: Mutations::UserCourseSet
end
