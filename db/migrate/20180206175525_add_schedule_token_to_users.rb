# frozen_string_literal: true

# Add schedule_token to User model as identifier for shared schedules
class AddScheduleTokenToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :schedule_token, :string

    User.where(schedule_token: nil).each(&:regenerate_schedule_token)
  end

  def down
    remove_column :users, :schedule_token
  end
end
