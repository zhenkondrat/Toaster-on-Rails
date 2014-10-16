class AddDateStampToResults < ActiveRecord::Migration
  def up
    add_column :results, :created_at, :datetime
  end

  def down
    remove_column :results, :created_at
  end
end
