class AddPrereqToCourses < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :courses, :courses, options = {column: "prereq"}
  end
end
