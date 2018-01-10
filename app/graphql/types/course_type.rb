# frozen_string_literal: true

Types::CourseType = GraphQL::ObjectType.define do
  name 'Course'
  description 'Represents a course in Curricle'

  # TODO: Determine (better) descriptions for these fields
  field :academic_group, !types.String, 'The academic group of the course'
  field :catalog_number, !types.Int, 'The catalog number of the course'
  field :component, types.String
  field :course_description_long, types.String, 'The extended description of the course'
  field :id, !types.ID, 'The ID of the course'
  field :subject, !types.String, 'The subject of the course'
  field :term_name, !types.String, 'The term name of the course'
  field :term_year, !types.Int, 'The year in which the course is offered'
  field :title, !types.String, 'The title of the course'
  field :units_maximum, types.Int, 'The maximum units of the course'
end
