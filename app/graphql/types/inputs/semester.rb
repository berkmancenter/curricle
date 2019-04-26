# frozen_string_literal: true

module Types
  module Inputs
    class Semester < Types::BaseInputObject
      description 'An input object representing a semester term name and year'

      argument :term_name, Types::Enums::TermName, required: true
      argument :term_year, Integer, required: true
    end
  end
end
