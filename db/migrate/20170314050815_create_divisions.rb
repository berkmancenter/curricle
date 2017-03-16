class CreateDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :division_mappings do |t|
      t.string :academic_group
      t.string :subject_description
      t.string :division
      t.string :division_description

      t.timestamps
    end
  end
end
