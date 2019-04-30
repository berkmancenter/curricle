# frozen_string_literal: true

require_relative 'curricle_importer'

class CurricleCourseMeetingPatternImporter < CurricleImporter
  TABLE_NAME = 'course_meeting_patterns'

  SQL_COLUMNS = %w[
    external_course_id
    term_name
    term_year
    class_section
    class_meeting_number
    meeting_time_start
    meeting_time_end
    meets_on_monday
    meets_on_tuesday
    meets_on_wednesday
    meets_on_thursday
    meets_on_friday
    meets_on_saturday
    meets_on_sunday
    start_date
    end_date
    external_facility_id
    facility_description
    course_id
    created_at
    updated_at
  ].freeze

  UNIQUE_KEY_COLUMNS = ['id'].freeze

  def format_row(row) # rubocop:disable Metrics/MethodLength
    external_course_id = row[:course_id].to_i
    term_year, term_name = row[:term_description].to_s.split(' ')
    term_year = term_year.to_i
    key = "#{term_year}#{term_name}#{external_course_id}#{row[:class_section]}"
    meeting_time_start = Time.strptime(row[:meeting_time_start], '%d-%b-%y %I.%M.%S.000000000 %P') if row[:meeting_time_start]
    meeting_time_end = Time.strptime(row[:meeting_time_end], '%d-%b-%y %I.%M.%S.000000000 %P') if row[:meeting_time_end]
    course_id = COURSES_CACHE[key]

    return if course_id.blank?

    [
      external_course_id,
      term_name,
      term_year,
      row[:class_section],
      row[:class_mtg_nbr],
      meeting_time_start,
      meeting_time_end,
      row[:mon] == 'Y',
      row[:tues] == 'Y',
      row[:wed] == 'Y',
      row[:thurs] == 'Y',
      row[:fri] == 'Y',
      row[:sat] == 'Y',
      row[:sun] == 'Y',
      Date.parse(row[:start_dt]),
      Date.parse(row[:end_dt]),
      row[:facility_id],
      row[:facility_description],
      course_id,
      Time.current,
      Time.current
    ]
  end
end

CourseMeetingPattern.delete_all

CurricleCourseMeetingPatternImporter.new.run
