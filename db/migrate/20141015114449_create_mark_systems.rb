class CreateMarkSystems < ActiveRecord::Migration
  def up
    create_table :mark_systems do |t|
      t.string :name
    end
  end

  def down
    drop_table :mark_systems
  end
end
