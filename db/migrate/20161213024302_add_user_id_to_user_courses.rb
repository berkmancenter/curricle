class AddUserIdToUserCourses < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :user_courses, :users
  end
end
