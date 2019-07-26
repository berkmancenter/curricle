# frozen_string_literal: true

require_relative 'curricle_importer'

# Associate Q guide course IDs with Curricle course records
class CourseQGuideCourseIdImporter < CurricleImporter
  def initialize
    @csv_file = Rails.root.join('lib', 'seeds', 'q_guide_course_ids.csv')
    @progressbar = progressbar(@csv_file)
  end

  def run
    CSV.foreach(@csv_file, headers: true) do |row|
      course = Course.find_by(external_course_id: row['sis_id'], term_code: row['strm'])

      @progressbar.increment!

      next if course.blank?

      course.update(q_guide_course_id: row['q_id'])
    end
  end
end

CourseQGuideCourseIdImporter.new.run
