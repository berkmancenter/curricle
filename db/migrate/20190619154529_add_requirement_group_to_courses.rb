class AddRequirementGroupToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :requirement_group, :string
    add_column :courses, :requirement_group_description, :string
  end
end
