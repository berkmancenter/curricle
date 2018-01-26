# frozen_string_literal: true

# TODO: Figure out why ApplyToEnum doesn't load when placed in its own file
ApplyToEnum = GraphQL::EnumType.define do
  name 'ApplyToField'
  description 'Field that keywords can be applied to when searching courses'

  value('COURSE_ID', 'Course ID')
  value('DESCRIPTION', 'Description')
  value('INSTRUCTOR', 'Instructor')
  value('READINGS', 'Readings')
  value('TITLE', 'Title')
  value('ID', 'Internal ID')
end

Inputs::DeluxeKeywordInput = GraphQL::InputObjectType.define do
  name 'DeluxeKeywordInput'
  description 'An input object representing arguments for a course'

  argument :text, !types.String, 'Keyword text'
  argument :applyTo, !types[ApplyToEnum], 'Fields that the keyword search should be applied to', as: :fields
  argument :weight, types.Int, 'Weight of the keyword search'
end
