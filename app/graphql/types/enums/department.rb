# frozen_string_literal: true

module Types
  module Enums
    class Department < Types::BaseEnum
      generate_enum_values(:subject_academic_org_description)
    end
  end
end
