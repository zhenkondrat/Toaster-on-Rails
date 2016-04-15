class AddUserToMarkSystems < ActiveRecord::Migration
  def change
    add_column :mark_systems, :user_id, :integer
  end
end
