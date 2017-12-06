# frozen_string_literal: true

class CourseReading < ApplicationRecord
  belongs_to :course

  def author_full_name
    "#{first_name} #{last_name}"
  end
end
