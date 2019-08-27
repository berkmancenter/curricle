class RemoveExternalUserIdFromUserCourses < ActiveRecord::Migration[5.2]
  def change
    remove_index :user_courses, %i[course_id external_user_id]
    remove_column :user_courses, :external_user_id, :string
  end
end
