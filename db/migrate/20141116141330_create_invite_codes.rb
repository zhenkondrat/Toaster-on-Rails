class CreateInviteCodes < ActiveRecord::Migration
  def up
    create_table :invite_codes do |t|
      t.string :token, size: 6
      t.date   :date
    end
  end

  def down
    drop_table :invite_codes
  end
end
