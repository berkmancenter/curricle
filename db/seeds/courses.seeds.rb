# frozen_string_literal: true

require_relative 'curricle_importer'

class CurricleCourseImporter < CurricleImporter
  TABLE_NAME = 'courses'

  SQL_COLUMNS = %w[
    external_course_id
    offer_number
    course_description
    title
    term_name
    term_year
    term_code
    session_code
    academic_year
    class_section
    component
    subject
    subject_description
    subject_academic_org_description
    class_academic_org_description
    academic_group
    academic_group_description
    grading_basis_description
    term_pattern_code
    term_pattern_description
    units_maximum
    catalog_number
    course_description_long
    course_note
    created_at
    updated_at
  ].freeze

  UNIQUE_KEY_COLUMNS = %w[
    external_course_id
    offer_number
    term_code
    session_code
    class_section
  ].freeze

  def format_row(row) # rubocop:disable Metrics/MethodLength
    external_course_id = row[:course_id].to_i
    term_year, term_name = row[:term_description].to_s.split(' ')
    term_year = term_year.to_i

    # These fields are used in the composite key in the database and are required,
    # skip the rows that have incomplete data
    return if (row[:course_offer_number] && row[:session_code] && row[:class_section]).blank?

    return if row[:class_status] == 'X' # do not import courses that have been cancelled
    return if row[:class_type] == 'N' # do not import discussion sections

    [
      external_course_id,
      row[:course_offer_number],
      row[:course_descr],
      row[:course_title_long],
      term_name,
      term_year,
      row[:term_code],
      row[:session_code],
      row[:academic_year],
      row[:class_section],
      row[:component_description],
      row[:subject],
      row[:subject_description],
      row[:subject_acad_org_description],
      row[:class_acad_org_description],
      row[:acad_group],
      row[:acad_group_description],
      row[:grading_gasis_description],
      row[:term_pattern_code],
      row[:term_pattern_description],
      row[:units_maximum].to_i,
      row[:catalog_number],
      row[:course_descrlong],
      row[:course_note],
      Time.current,
      Time.current
    ]
  end

  private

  # courses.csv has newlines in rows so we can't rely on `wc -l` to count the number of rows
  def csv_lines(csv_file)
    puts 'Counting the number of rows in the courses CSV file..'
    CSV.read(csv_file).length - 1
  end
end

CurricleCourseImporter.new.run
