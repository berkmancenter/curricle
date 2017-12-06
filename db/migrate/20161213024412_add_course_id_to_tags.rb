class AddCourseIdToTags < ActiveRecord::Migration[5.0]
  def change
     add_foreign_key :tags, :courses
  end
end
