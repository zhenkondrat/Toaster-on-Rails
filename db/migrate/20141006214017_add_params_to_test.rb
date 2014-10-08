class AddParamsToTest < ActiveRecord::Migration
  def up
    add_column :tests, :questions_count, :integer
    add_column :tests, :question_time, :integer
  end

  def down
    remove_column :tests, :questions_count
    remove_column :tests, :question_time
  end
end
