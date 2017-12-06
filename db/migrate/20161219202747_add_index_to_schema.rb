class AddIndexToSchema < ActiveRecord::Migration[5.0]
  def change
    add_index :courses, :title, using: :gin
    add_index :courses, :course_description_long, using: :gin
    add_index :courses, :course_note, using: :gin
  end
end
