# frozen_string_literal: true

# Use strings because Catalog IDs sometimes have alpha characters in them
class ChangeCourseCatalogIdsFromIntToString < ActiveRecord::Migration[5.2]
  def up
    change_column :courses, :catalog_number, :string
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
