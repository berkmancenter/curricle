# frozen_string_literal: true

module Types
  module Enums
    class CourseLevel < Types::BaseEnum
      value('GRADCOURSE', 'Graduate Course')
      value('NOLEVEL', 'No Course Level')
      value('PRIMGRAD', 'Primarily for Graduate Students')
      value('PRIMUGRD', 'Primarily for Undergraduate Students')
      value('UGRDGRAD', 'For Undergraduate and Graduate Students')
    end
  end
end
