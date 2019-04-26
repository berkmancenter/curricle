# frozen_string_literal: true

module Types
  module Enums
    class TermName < Types::BaseEnum
      description 'Term name for setting course search range'

      value('SPRING', 'Spring', value: 'Spring')
      value('SUMMER', 'Summer', value: 'Summer')
      value('FALL', 'Fall', value: 'Fall')
    end
  end
end
