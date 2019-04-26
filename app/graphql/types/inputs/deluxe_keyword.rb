# frozen_string_literal: true

module Types
  module Inputs
    class DeluxeKeyword < Types::BaseInputObject
      description 'An input object representing arguments for a course'

      argument :text, String, 'Keyword text', required: true
      argument :applyTo, [Types::Enums::KeywordFields], 'Fields that the keyword search should be applied to', as: :fields, required: true
      argument :weight, Integer, 'Weight of the keyword search', required: false
    end
  end
end
