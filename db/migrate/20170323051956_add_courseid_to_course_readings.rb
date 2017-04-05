class AddCourseidToCourseReadings < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :course_readings, :courses
  end
end
