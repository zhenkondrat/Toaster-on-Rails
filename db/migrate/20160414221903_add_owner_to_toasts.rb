class AddOwnerToToasts < ActiveRecord::Migration
  def change
    add_column :toasts, :owner_id, :integer
  end
end
