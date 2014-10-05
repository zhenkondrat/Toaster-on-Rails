class CreateAnswer3s < ActiveRecord::Migration
  def up
    create_table :answer3s do |t|
      t.integer :question_id
      t.text    :field
      t.boolean :side
    end
  end

  def down
    drop_table :answer3s
  end
end
