class AddIndexToUserCourses < ActiveRecord::Migration[5.2]
  def change
    add_index(
      :user_courses,
      %i[course_id external_user_id],
      unique: true
    )
  end
end
