class CreateCourseReadings < ActiveRecord::Migration[5.0]
  def change
    create_table :course_readings do |t|
      t.integer :external_course_id
      t.integer :external_citation_id
      t.integer :course_id
      t.string :title
      t.string :author_last_name
      t.string :author_first_name
      t.string :url
      t.text :annotation
      t.boolean :required, default: false

      t.timestamps
    end
  end
end
