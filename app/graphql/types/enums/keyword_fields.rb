# frozen_string_literal: true

module Types
  module Enums
    class KeywordFields < Types::BaseEnum
      description 'Field that keywords can be applied to when searching courses'

      value('COURSE_ID', 'Course ID')
      value('DESCRIPTION', 'Description')
      value('INSTRUCTOR', 'Instructor')
      value('NOTES', 'Class Notes')
      value('READINGS', 'Readings')
      value('TITLE', 'Title')
      value('ID', 'Internal ID')
    end
  end
end
