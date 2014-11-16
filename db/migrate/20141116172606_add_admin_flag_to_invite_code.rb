class AddAdminFlagToInviteCode < ActiveRecord::Migration
  def up
    add_column :invite_codes, :admin, :boolean
  end

  def down
    remove_column :invite_codes, :admin
  end
end
