# frozen_string_literal: true

module Types
  module Inputs
    class TimeRange < Types::BaseInputObject
      description 'An input object representing a specific day and start/end time'

      argument :day_name, Types::Enums::DayName, required: true
      argument :time_start, Integer, required: true
      argument :time_end, Integer, required: true
    end
  end
end
