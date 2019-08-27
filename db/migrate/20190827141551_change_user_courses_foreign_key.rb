class ChangeUserCoursesForeignKey < ActiveRecord::Migration[5.2]
  def up
    raise 'Cannot migrate UserCourses until all Users have huids' if User.distinct.pluck(:huid).include?(nil)

    id_map = UserCourse.pluck(:id, :user_id)

    remove_foreign_key :user_courses, :users
    change_column :user_courses, :user_id, :string

    id_map.each do |user_course_id, user_id|
      huid = User.find(user_id).huid
      uc = UserCourse.find(user_course_id)

      uc.update_attribute(:user_id, huid)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
