class RenameColumnInAnswer3s < ActiveRecord::Migration
  def up
    rename_column :answer3s, :compare, :answer3_id
  end

  def down
    rename_column :answer3s, :answer3_id, :compare
  end
end
