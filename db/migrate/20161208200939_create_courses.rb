class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.integer :external_course_id
      t.text :course_description
      t.string :title
      t.string :term_name
      t.integer :term_year
      t.integer :academic_year
      t.string :component
      t.integer :prereq
      t.string :subject
      t.text :subject_description
      t.text :subject_academic_org_description
      t.string :academic_group
      t.text :academic_group_description
      t.text :grading_basis_description
      t.string :term_pattern_code
      t.text :term_pattern_description
      t.integer :units_maximum
      t.integer :catalog_number
      t.text :course_description_long
      t.text :course_note
      
      t.timestamps
    end
  end
end
