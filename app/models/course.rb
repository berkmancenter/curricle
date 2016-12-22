class Course < ApplicationRecord
  include PgSearch

  has_many :course_meeting_patterns
  has_many :course_instructors

  pg_search_scope :search_for, against: %i(title course_description_long course_note), using: { tsearch: { dictionary: "english" } }

  def self.for_day(day, query_params = {})
    query_params[:id] = CourseMeetingPattern.select(:course_id).where("meets_on_#{day}": true)
    Course.where(query_params).distinct
  end

  def self.subjects(query = nil)
    # TODO: figure out if we can replace uniq with distinct
    query.pluck(:subject_academic_org_description).uniq
  end

  def meeting
    course_meeting_patterns.find_by(
      term_name: term_name,
      term_year: term_year,
      class_section: class_section
    )
  end

  def instructor
    course_instructors.find_by(
      term_name: term_name,
      term_year: term_year,
      class_section: class_section
    )
  end
end
