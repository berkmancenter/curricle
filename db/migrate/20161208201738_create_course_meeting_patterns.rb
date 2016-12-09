class CreateCourseMeetingPatterns < ActiveRecord::Migration[5.0]
  def change
    create_table :course_meeting_patterns do |t|
      t.integer :external_course_id
      t.integer :course_id
      t.datetime :meeting_time_start
      t.datetime :meeting_time_end
      t.boolean :meets_on_monday
      t.boolean :meets_on_tuesday
      t.boolean :meets_on_wednesday
      t.boolean :meets_on_thursday
      t.boolean :meets_on_friday
      t.boolean :meets_on_saturday
      t.boolean :meets_on_sunday
      t.date :start_date
      t.date :end_date
      t.string :external_facility_id
      t.text :facilitly_description
     
      t.timestamps
    end
  end
end
