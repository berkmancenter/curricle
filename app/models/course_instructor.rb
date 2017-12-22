# frozen_string_literal: true

class CourseInstructor < ApplicationRecord
  belongs_to :course

  searchable do
    integer :external_course_id
    integer :course_id, references: Course
    string :term_name
    integer :term_year
    string :class_section
    string :class_meeting_number
    string :instructor_role
    string :print_instructor_flag
    text :first_name
    text :middle_name
    text :last_name
    string :name_prefix
    string :name_suffix
    string :email
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
