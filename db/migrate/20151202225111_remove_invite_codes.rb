class RemoveInviteCodes < ActiveRecord::Migration
  def up
    drop_table :invite_codes
  end

  def down
    create_table :invite_codes do |t|
      t.string :token, size: 6
      t.string :role
      t.timestamps
    end
  end
end
