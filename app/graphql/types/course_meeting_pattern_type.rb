# frozen_string_literal: true

module Types
  class CourseMeetingPatternType < Types::BaseObject
    description 'Represents a course meeting pattern in Curricle'

    field :class_meeting_number, String, null: true
    field :class_section, String, null: true
    field :course, Types::CourseType, null: true
    field :created_at, String, null: false
    field :end_date, String, null: true
    field :external_course_id, Integer, null: true
    field :external_facility_id, String, null: true
    field :facility_description, String, null: true
    field :id, ID, null: false
    field :meeting_time_end, String, null: true
    field :meeting_time_end_tod, String, 'Meeting time end (time of day)', null: true
    field :meeting_time_start, String, null: true
    field :meeting_time_start_tod, String, 'Meeting time start (time of day)', null: true
    field :meets_on_friday, Boolean, null: true
    field :meets_on_monday, Boolean, null: true
    field :meets_on_saturday, Boolean, null: true
    field :meets_on_sunday, Boolean, null: true
    field :meets_on_thursday, Boolean, null: true
    field :meets_on_tuesday, Boolean, null: true
    field :meets_on_wednesday, Boolean, null: true
    field :start_date, String, null: true
    field :term_name, String, null: true
    field :term_year, Integer, null: true
    field :updated_at, String, null: false
  end
end
