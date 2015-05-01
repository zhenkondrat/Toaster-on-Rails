class AddRolesToInviteCodes < ActiveRecord::Migration
  def up
    remove_column :invite_codes, :admin
    remove_column :invite_codes, :date
    add_column :invite_codes, :role, :string
  end

  def down
    add_column :invite_codes, :admin, :boolean
    add_column :invite_codes, :date, :datetime
    remove_column :invite_codes, :role
  end
end
