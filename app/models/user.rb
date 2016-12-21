class User < ApplicationRecord

  has_many :user_courses
  has_many :courses, through: :user_courses

  def added?(course_id)
    courses.find_by(id: course_id)
  end
end
