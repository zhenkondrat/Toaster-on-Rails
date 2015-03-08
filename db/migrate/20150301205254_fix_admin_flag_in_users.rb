class FixAdminFlagInUsers < ActiveRecord::Migration
  def up
    change_column_default :users, :admin, false
  end

  def down
    # it will not have need to be reverted
  end
end
