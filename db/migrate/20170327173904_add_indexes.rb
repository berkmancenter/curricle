class AddIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :course_meeting_patterns, :course_id
    add_index :course_meeting_patterns, :meets_on_monday
    add_index :course_meeting_patterns, :meets_on_tuesday
    add_index :course_meeting_patterns, :meets_on_wednesday
    add_index :course_meeting_patterns, :meets_on_thursday
    add_index :course_meeting_patterns, :meets_on_friday
    add_index :course_meeting_patterns, :meets_on_saturday
    add_index :course_meeting_patterns, :meets_on_sunday
    add_index :courses, :division_description
    add_index :courses, :term_name
    add_index :courses, :term_year
    add_index :courses, :class_section
  end
end
