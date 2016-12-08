class CreateCourseMeetingPatterns < ActiveRecord::Migration[5.0]
  def change
    create_table :course_meeting_patterns do |t|
      t.integer :course_id
      t.datetime :meeting_time_start
      t.datetime :meeting_time_end
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday
      t.date :start_date
      t.date :end_date
      t.string :facility_id
      t.text :facilitly_description

      t.timestamps
    end
  end
end
