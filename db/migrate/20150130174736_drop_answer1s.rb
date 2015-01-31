class DropAnswer1s < ActiveRecord::Migration
  def up
    drop_table :answer1s
    add_column :questions, :is_right, :boolean
  end

  def down
    create_table :answer1s do |t|
      t.integer :question_id, nil: false
      t.boolean :is_right, nil: false
    end
    remove_column :questions, :is_right
  end
end
