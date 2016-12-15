class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :external_user_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :major

      t.timestamps
    end
  end
end
