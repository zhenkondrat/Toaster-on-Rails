class AddAdditionalToResults < ActiveRecord::Migration
  def up
    add_column :results, :additional, :jsonb
  end

  def down
    remove_column :results, :additional
  end
end
