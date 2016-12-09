class AddCourseidToCourseInstructors < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :course_instructors, :courses
  end
end
