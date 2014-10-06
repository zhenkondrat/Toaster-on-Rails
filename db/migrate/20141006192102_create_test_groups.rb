class CreateTestGroups < ActiveRecord::Migration
  def up
    create_table :test_groups do |t|
      t.integer :group_id
      t.integer :test_id
    end
  end

  def down
    drop_table :test_groups
  end
end
