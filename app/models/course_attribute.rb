class CourseAttribute < ApplicationRecord
  belongs_to :course

  validates :class_section, presence: true
  validates :course_id, presence: true
  validates :external_course_id, presence: true
  validates :session_code, presence: true
  validates :term_code, presence: true
end
