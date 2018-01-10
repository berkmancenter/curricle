# frozen_string_literal: true

Inputs::DeluxeKeywordInput = GraphQL::InputObjectType.define do
  name 'DeluxeKeywordInput'
  description 'An input object representing arguments for a course'

  argument :text, !types.String, 'Keyword text'
  argument :applyTo, types[types.String], 'Fields that the keyword search should be applied to', as: :fields
  argument :weight, types.Int, 'Weight of the keyword search'
end
