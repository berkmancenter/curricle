# frozen_string_literal: true

require_relative 'curricle_importer'

# Associate Q guide course IDs with Curricle course records
class CourseQGuideCourseIdImporter < CurricleImporter
  def initialize
    @id_map = {}
    @csv_file = Rails.root.join('lib', 'seeds', 'q_guide_course_ids.csv')

    puts 'Counting the number of rows in the Q guide CSV file..'

    # map course IDs to their most recent Q IDs
    CSV.foreach(@csv_file, headers: true) { |row| @id_map[row['sis_id']] = row['q_id'] }

    @progressbar = ProgressBar.new(@id_map.length)
  end

  def run
    @id_map.each do |external_course_id, q_guide_course_id|
      Course.where(external_course_id: external_course_id).update_all(q_guide_course_id: q_guide_course_id)

      @progressbar.increment!
    end
  end
end

CourseQGuideCourseIdImporter.new.run
