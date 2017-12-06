class AddUserIdToTags < ActiveRecord::Migration[5.0]
  def change
     add_foreign_key :tags, :users
  end
end
