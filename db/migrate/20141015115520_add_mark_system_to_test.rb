class AddMarkSystemToTest < ActiveRecord::Migration
  def up
    add_column :tests, :mark_system, :integer
  end

  def down
    remove_column :tests, :mark_system
  end
end
