class AddApiTokenToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :api_token, :string

    User.where(api_token: nil).each { |user| user.regenerate_api_token }
  end

  def down
    remove_column :users, :api_token
  end
end
