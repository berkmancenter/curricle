class ModifyIndexes < ActiveRecord::Migration[5.1]
  def change
    remove_index :courses, :course_description_long
    add_index :courses, "to_tsvector('english', course_description_long)", using: :gin
  end
end
