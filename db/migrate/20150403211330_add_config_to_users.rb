class AddConfigToUsers < ActiveRecord::Migration
  def up
    add_column :users, :config, :string
  end

  def down
    remove_column :users, :config
  end
end
