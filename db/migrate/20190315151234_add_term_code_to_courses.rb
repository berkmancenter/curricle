class AddTermCodeToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :term_code, :integer
  end
end
