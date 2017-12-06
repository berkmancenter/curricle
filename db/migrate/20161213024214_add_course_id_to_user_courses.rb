class AddCourseIdToUserCourses < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :user_courses, :courses
  end
end
