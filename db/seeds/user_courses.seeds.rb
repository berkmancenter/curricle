# frozen_string_literal: true

require_relative 'curricle_importer'

class CurricleUserCoursesImporter < CurricleImporter
  TABLE_NAME = 'user_courses'

  SQL_COLUMNS = %w[
    course_id
    user_id
    include_in_path
    imported
    created_at
    updated_at
  ].freeze

  UNIQUE_KEY_COLUMNS = ['id'].freeze

  def format_row(row) # rubocop:disable Metrics/MethodLength
    huid = row[:emplid]
    external_course_id = row[:course_id].to_i
    key = "#{row[:term_code]}#{external_course_id}#{row[:class_section]}"
    course_id = COURSES_CACHE[key]

    return if course_id.blank? || huid.blank?

    [
      course_id,
      huid,
      true,
      true,
      Time.current,
      Time.current
    ]
  end
end

UserCourse.where(imported: true).delete_all

CurricleUserCoursesImporter.new.run
