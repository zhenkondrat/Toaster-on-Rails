class AddMarkSystemIdToMarks < ActiveRecord::Migration
  def up
    add_column :marks, :mark_system_id, :integer, after: :id
  end

  def down
    remove_column :marks, :mark_system_id
  end
end
