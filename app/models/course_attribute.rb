class CourseAttribute < ApplicationRecord
  belongs_to :course

  validates :class_section, presence: true
  validates :course_id, presence: true
  validates :external_course_id, presence: true
  validates :session_code, presence: true
  validates :term_code, presence: true

  searchable do
    integer :id
    integer :course_id, references: Course
    string :crse_attr_value
    string :crse_attr_value_description
    string :crse_attribute
    string :crse_attribute_description
  end

  scope :course_level, -> { where(crse_attribute_description: 'FAS: Course Level') }
end
