class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :course_meeting_pattern
end
