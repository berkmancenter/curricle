# frozen_string_literal: true

DayNameEnum = GraphQL::EnumType.define do
  name 'DayNameField'
  description 'Day name for day/time course search range'

  value('MONDAY', 'Monday', value: 'Monday')
  value('TUESDAY', 'Tuesday', value: 'Tuesday')
  value('WEDNESDAY', 'Wednesday', value: 'Wednesday')
  value('THURSDAY', 'Thursday', value: 'Thursday')
  value('FRIDAY', 'Friday', value: 'Friday')
end

Inputs::TimeRangeInput = GraphQL::InputObjectType.define do
  name 'TimeRangeInput'
  description 'An input object representing a specific day and start/end time'

  argument :day_name, !DayNameEnum
  argument :time_start, !types.Int
  argument :time_end, !types.Int
end
