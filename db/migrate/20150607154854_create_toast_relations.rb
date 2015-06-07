class CreateToastRelations < ActiveRecord::Migration
  def up
    create_table :toast_relations do |t|
      t.integer :parent_id
      t.integer :child_id
      t.integer :percent, default: 100
    end
  end

  def down
    drop_table :toast_relations
  end
end
