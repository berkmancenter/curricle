class AddExternalUserIdToUserCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :user_courses, :external_user_id, :string
  end
end
