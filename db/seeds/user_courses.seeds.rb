# frozen_string_literal: true

require_relative 'curricle_importer'

class CurricleUserCoursesImporter < CurricleImporter
  TABLE_NAME = 'user_courses'

  SQL_COLUMNS = %w[
    course_id
    user_id
    external_user_id
    include_in_path
    imported
    created_at
    updated_at
  ].freeze

  USERS_CACHE =
    User
    .pluck(:id, :huid)
    .each_with_object({}) do |el, hash|
      hash[el[1]] = el[0]
    end

  UNIQUE_KEY_COLUMNS = %w[course_id external_user_id].freeze

  def format_row(row) # rubocop:disable Metrics/MethodLength
    empl_id = row[:emplid]
    user_id = USERS_CACHE[empl_id]
    external_course_id = row[:course_id].to_i
    key = "#{row[:term_code]}#{external_course_id}#{row[:class_section]}"
    course_id = COURSES_CACHE[key]

    return if course_id.blank? || user_id.blank?

    [
      course_id,
      user_id,
      empl_id,
      true,
      true,
      Time.current,
      Time.current
    ]
  end
end

CurricleUserCoursesImporter.new.run
