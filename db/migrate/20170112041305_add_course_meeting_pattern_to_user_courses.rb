class AddCourseMeetingPatternToUserCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :user_courses, :course_meeting_pattern_id, :integer
    add_foreign_key :user_courses, :course_meeting_patterns
  end
end
