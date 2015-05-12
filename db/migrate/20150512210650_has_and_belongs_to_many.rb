class HasAndBelongsToMany < ActiveRecord::Migration
  def up
    rename_table :toast_groups, :groups_toasts
    rename_table :user_groups, :groups_users
  end

  def down
    rename_table :groups_toasts, :toast_groups
    rename_table :users_groups, :user_groups
  end
end
