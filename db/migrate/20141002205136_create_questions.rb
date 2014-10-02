class CreateQuestions < ActiveRecord::Migration
  def up
    create_table(:questions) do |t|
      t.integer :test_id
      t.text  :condition
      t.integer  :type
    end
  end

  def down
    drop_table(:questions)
  end
end
