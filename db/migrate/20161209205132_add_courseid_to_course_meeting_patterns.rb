class AddCourseidToCourseMeetingPatterns < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :course_meeting_patterns, :courses
  end
end
