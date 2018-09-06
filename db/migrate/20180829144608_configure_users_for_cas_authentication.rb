# frozen_string_literal: true

# Add User columns to support CAS-based authentication with
# the devise_cas_authenticatable gem
class ConfigureUsersForCasAuthentication < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :display_name, :string
    add_column :users, :given_name, :string
    add_column :users, :huid, :string
    add_column :users, :surname, :string
    add_column :users, :username, :string, null: false, default: ''

    add_index :users, :username, unique: true
  end
end
