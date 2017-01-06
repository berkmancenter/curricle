class AddClassAcadOrgToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :class_academic_org_description, :text
  end
end
