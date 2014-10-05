class CreateAnswer2s < ActiveRecord::Migration
  def up
    create_table :answer2s do |t|
      t.integer :question_id
      t.string  :answer
      t.boolean :is_right
    end
  end

  def down
    drop_table :answer2s
  end
end
