class AddCompareToAnswer3s < ActiveRecord::Migration
  def up
    add_column :answer3s, :compare, :integer
  end

  def down
    remove_column :answer3s, :compare, :integer
  end
end
