class AddImportedToUserCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :user_courses, :imported, :boolean, default: false, null: false
  end
end
