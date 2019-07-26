class AddQGuideCourseIdToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :q_guide_course_id, :integer
  end
end
