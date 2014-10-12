class CreateResults < ActiveRecord::Migration
  def up
    create_table :results do |t|
      t.integer :test_id
      t.integer :user_id
      t.decimal :mark, precision: 3, scale: 2
    end
  end

  def down
    drop_table :results
  end
end
