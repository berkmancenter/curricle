class User < ApplicationRecord

  has_many :user_courses
  has_many :courses, through: :user_courses
  has_many :path_meeting_patterns, through: :user_courses, source: :course_meeting_pattern

  def added?(course_id)
    courses.find_by(id: course_id)
  end

  def in_path?(pattern_id)
    user_courses.find_by(
      include_in_path: true,
      course_meeting_pattern_id: pattern_id
    )
  end

  def patterns_for_all_courses(by_day = nil)
    query = CourseMeetingPattern.where(course: courses)
    query = query.where("meets_on_#{by_day}": true) if by_day.present?
    query
  end
end
