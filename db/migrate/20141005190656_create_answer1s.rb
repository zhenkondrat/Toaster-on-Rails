class CreateAnswer1s < ActiveRecord::Migration
  def up
    create_table :answer1s do |t|
      t.integer :question_id
      t.boolean :is_right
    end
  end

  def down
    drop_table :answer1s
  end

end
