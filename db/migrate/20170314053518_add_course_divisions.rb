class AddCourseDivisions < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :division, :string
    add_column :courses, :division_description, :string
  end
end
