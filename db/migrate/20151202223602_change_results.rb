class ChangeResults < ActiveRecord::Migration
  def up
    remove_column :results, :answers

    change_table :results do |t|
      t.rename :mark, :hit
      t.jsonb :answers
    end
  end

  def down
    remove_column :results, :answers

    change_table :results do |t|
      t.rename :hit, :mark
      t.string :answers
    end
  end
end
