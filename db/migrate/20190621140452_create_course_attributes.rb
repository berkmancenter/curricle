class CreateCourseAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :course_attributes do |t|
      t.integer :external_course_id, null: false
      t.integer :course_offer_number
      t.integer :course_id, null: false
      t.integer :term_code, null: false
      t.string :term_description , null: false
      t.string :session_code, null: false
      t.string :class_section, null: false
      t.string :crse_attribute
      t.string :crse_attribute_description
      t.string :crse_attr_value
      t.string :crse_attr_value_description
      t.string :academic_career
      t.string :bracketed_flag
      t.timestamps

      t.references :course, foreign_key: true
    end
  end
end
