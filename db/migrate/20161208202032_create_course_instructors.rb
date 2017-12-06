class CreateCourseInstructors < ActiveRecord::Migration[5.0]
  def change
    create_table :course_instructors do |t|
      t.integer :external_course_id
      t.integer :course_id
      t.string :term_name
      t.integer :term_year
      t.string :class_section
      t.string :class_meeting_number
      t.string :instructor_role
      t.string :print_instructor_flag
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :name_prefix
      t.string :name_suffix
      t.string :email
    
      t.timestamps
    end
  end
end
