# frozen_string_literal: true

module Types
  module Enums
    class DayName < Types::BaseEnum
      description 'Day name for day/time course search range'

      value('MONDAY', 'Monday', value: 'Monday')
      value('TUESDAY', 'Tuesday', value: 'Tuesday')
      value('WEDNESDAY', 'Wednesday', value: 'Wednesday')
      value('THURSDAY', 'Thursday', value: 'Thursday')
      value('FRIDAY', 'Friday', value: 'Friday')
    end
  end
end
