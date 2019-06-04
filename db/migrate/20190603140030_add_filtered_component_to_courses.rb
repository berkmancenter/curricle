class AddFilteredComponentToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :component_filtered, :string
  end
end
