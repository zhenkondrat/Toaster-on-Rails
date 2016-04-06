class AddDeviseFieldsToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
    end

    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
  end

  def down
    change_table :users do |t|
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
    end

    remove_index :users, :reset_password_token
    remove_index :users, :confirmation_token
  end
end
