class AddConstraintsToCourses < ActiveRecord::Migration[5.2]
  def change
    change_column_null :courses, :external_course_id, false
    change_column_null :courses, :offer_number, false
    change_column_null :courses, :term_code, false
    change_column_null :courses, :session_code, false
    change_column_null :courses, :class_section, false
  end
end
