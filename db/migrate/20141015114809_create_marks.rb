class CreateMarks < ActiveRecord::Migration
  def up
    create_table :marks do |t|
      t.string   :presentation
      t.integer  :percent
    end
  end

  def down
    drop_table :marks
  end
end
