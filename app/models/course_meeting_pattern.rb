class CourseMeetingPattern < ApplicationRecord
  belongs_to :course

  def self.hours_range
    (8..20)
  end
end
