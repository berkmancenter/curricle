class AddSessionCodeToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :session_code, :string
  end
end
