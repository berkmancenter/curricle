class CreateUserCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :user_courses do |t|
      t.integer :user_id
      t.integer :course_id
      t.boolean :include_in_path
      
      t.timestamps
    end
  end
end
