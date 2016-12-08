class CreateCourseInstructors < ActiveRecord::Migration[5.0]
  def change
    create_table :course_instructors do |t|
      t.integer :course_id
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
