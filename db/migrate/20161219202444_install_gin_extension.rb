class InstallGinExtension < ActiveRecord::Migration[5.0]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS btree_gin;"
  end

  def down
    execute "DROP EXTENSION IF EXISTS btree_gin;"
  end
end
