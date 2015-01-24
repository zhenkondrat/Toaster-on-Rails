class RenameTestToToast < ActiveRecord::Migration
  def up
    rename_table :tests, :toasts
    rename_column :questions, :test_id, :toast_id
    rename_column :results, :test_id, :toast_id
    rename_column :test_groups, :test_id, :toast_id
    rename_table :test_groups, :toast_groups
  end

  def down
    rename_table :toasts, :tests
    rename_column :questions, :toast_id, :test_id
    rename_column :results, :toast_id, :test_id
    rename_column :toast_groups, :toast_id, :test_id
    rename_table :toast_groups, :test_groups
  end
end
