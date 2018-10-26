# frozen_string_literal: true

require_relative 'curricle_importer'

class CurricleCourseInstructorImporter < CurricleImporter
  TABLE_NAME = 'course_instructors'

  SQL_COLUMNS = %w[
    external_course_id
    term_name
    term_year
    class_section
    class_meeting_number
    instructor_role
    print_instructor_flag
    first_name
    middle_name
    last_name
    name_prefix
    name_suffix
    email
    course_id
    created_at
    updated_at
  ].freeze

  def format_row(row) # rubocop:disable Metrics/MethodLength
    term_year, term_name = row[:term_description].to_s.split(' ')
    term_year = term_year.to_i
    class_section = /^\d+$/.match?(row[:class_section].to_s) ? row[:class_section].to_i : row[:class_section]
    key = "#{term_year}#{term_name}#{row[:course_id]}#{class_section}"
    course_id = COURSES_CACHE[key]

    [
      row[:course_id],
      term_name,
      term_year,
      class_section,
      row[:class_meeting_number],
      row[:instructor_role],
      row[:print_instructor_flag],
      row[:instructor_first_name],
      row[:instructor_middle_name],
      row[:instructor_last_name],
      row[:instructor_name_prefix],
      row[:instructor_name_suffix],
      row[:instructor_email],
      course_id,
      Time.current,
      Time.current
    ]
  end
end

CurricleCourseInstructorImporter.new.run
