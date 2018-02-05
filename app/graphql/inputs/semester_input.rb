# frozen_string_literal: true

TermNameEnum = GraphQL::EnumType.define do
  name 'TermNameField'
  description 'Term name for setting course search range'

  value('SPRING', 'Spring', value: 'Spring')
  value('SUMMER', 'Summer', value: 'Summer')
  value('FALL', 'Fall', value: 'Fall')
end

Inputs::SemesterInput = GraphQL::InputObjectType.define do
  name 'SemesterInput'
  description 'An input object representing a semester term name and year'

  argument :term_name, !TermNameEnum
  argument :term_year, !types.Int
end
