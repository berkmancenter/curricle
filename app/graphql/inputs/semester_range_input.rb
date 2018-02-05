# frozen_string_literal: true

Inputs::SemesterRangeInput = GraphQL::InputObjectType.define do
  name 'SemesterRangeInput'
  description 'An input object representing a range of semesters to search'

  argument :start, !Inputs::SemesterInput, 'Starting semester'
  argument :end, Inputs::SemesterInput, 'Ending semester'
end
