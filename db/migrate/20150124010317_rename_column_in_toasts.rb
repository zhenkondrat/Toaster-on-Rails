class RenameColumnInToasts < ActiveRecord::Migration
  def up
    rename_column :toasts, :mark_system, :mark_system_id
  end

  def down
    rename_column :toasts, :mark_system_id, :mark_system
  end
end
