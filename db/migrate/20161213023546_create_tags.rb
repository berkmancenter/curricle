class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.integer :user_id
      t.integer :course_id 
      t.string  :name

      t.timestamps
    end
  end
end
