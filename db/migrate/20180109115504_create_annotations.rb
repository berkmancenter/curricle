class CreateAnnotations < ActiveRecord::Migration[5.0]
  def change
    create_table :annotations do |t|
      t.integer :user_id
      t.integer :course_id
      t.text :annotation
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
