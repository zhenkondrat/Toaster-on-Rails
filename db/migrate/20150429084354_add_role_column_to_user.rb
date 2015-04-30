class AddRoleColumnToUser < ActiveRecord::Migration
  def up
    remove_column :users, :admin

    add_column :users, :role, :string, limit: 7, default: 'student'
    add_index :users, :role
  end

  def down
    remove_column :users, :role
    add_column :users, :admin, :boolean
  end
end
