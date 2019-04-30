class AddOfferNumberToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :offer_number, :integer
  end
end
