# frozen_string_literal: true

require_relative 'curricle_importer'

class CurricleCourseAttributesImporter < CurricleImporter
  TABLE_NAME = 'course_attributes'

  SQL_COLUMNS = %w[
    external_course_id
    course_offer_number
    term_code
    term_description
    session_code
    class_section
    crse_attribute
    crse_attribute_description
    crse_attr_value
    crse_attr_value_description
    academic_career
    bracketed_flag
    course_id
    created_at
    updated_at
  ].freeze

  UNIQUE_KEY_COLUMNS = ['id'].freeze

  def format_row(row) # rubocop:disable Metrics/MethodLength
    external_course_id = row[:course_id].to_i
    key = "#{row[:term_code]}#{external_course_id}#{row[:class_section]}"
    course_id = COURSES_CACHE[key]

    return if course_id.blank?

    [
      external_course_id,
      row[:course_offer_number],
      row[:term_code],
      row[:term_description],
      row[:session_code],
      row[:class_section],
      row[:crse_attribute],
      row[:crse_attribute_description],
      row[:crse_attr_value],
      row[:crse_attr_value_description],
      row[:academic_career],
      row[:bracketed_flag],
      course_id,
      Time.current,
      Time.current
    ]
  end
end

CourseAttribute.delete_all

CurricleCourseAttributesImporter.new.run
