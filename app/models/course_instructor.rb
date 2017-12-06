# frozen_string_literal: true

class CourseInstructor < ApplicationRecord
  belongs_to :course

  def full_name
    "#{first_name} #{last_name}"
  end
end
