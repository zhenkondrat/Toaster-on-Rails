class RemoveToastRelations < ActiveRecord::Migration
  def up
    drop_table :toast_relations
  end

  def down
    create_table :toast_relations do |t|
      t.integer :parent_id
      t.integer :child_id
      t.integer :percent, default: 100
    end
  end
end
