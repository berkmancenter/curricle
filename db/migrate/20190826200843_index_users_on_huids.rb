class IndexUsersOnHuids < ActiveRecord::Migration[5.2]
  def change
    User.where(huid: nil).each { |user| user.update!(huid: user.username) }

    change_column_null :users, :huid, false
    add_index :users, :huid, unique: true
  end
end
