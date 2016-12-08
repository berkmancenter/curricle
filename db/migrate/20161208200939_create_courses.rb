class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.integer :course_id
      t.text :course_desc
      t.string :title
      t.string :term_name
      t.string :term_year
      t.integer :academic_year
      t.string :component
      t.string :subject
      t.text :subject_description
      t.string :prereq
      t.text :subject_academic_org_description
      t.string :academic_group
      t.text :academic_group_description
      t.text :grading_basis_description
      t.string :term_pattern_code
      t.text :term_pattern_description
      t.integer :units_maximum

      t.timestamps
    end
  end
end
