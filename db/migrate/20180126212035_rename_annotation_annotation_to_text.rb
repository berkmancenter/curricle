class RenameAnnotationAnnotationToText < ActiveRecord::Migration[5.1]
  def up
    rename_column :annotations, :annotation, :text
    change_column_null :annotations, :text, false
  end

  def down
    rename_column :annotations, :text, :annotation
    change_column_null :annotations, :annotation, true
  end
end
