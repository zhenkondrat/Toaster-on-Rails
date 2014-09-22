class CreateTests < ActiveRecord::Migration
  def up
    create_table(:tests) do |t|
      t.integer :subject_id
      t.string  :name
      t.integer :weight1
      t.integer :weight2
      t.integer :weight3
    end
  end

  def down
    drop_table(:tests)
  end
end
