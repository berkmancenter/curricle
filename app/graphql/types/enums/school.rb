# frozen_string_literal: true

module Types
  module Enums
    class School < Types::BaseEnum
      generate_enum_values(:academic_group)
    end
  end
end
