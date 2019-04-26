# frozen_string_literal: true

module Types
  module Inputs
    class SemesterRange < Types::BaseInputObject
      description 'An input object representing a range of semesters to search'

      argument :start, Types::Inputs::Semester, 'Starting semester', required: true
      argument :end, Types::Inputs::Semester, 'Ending semester', required: false
    end
  end
end
