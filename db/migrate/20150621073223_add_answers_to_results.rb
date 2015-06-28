class AddAnswersToResults < ActiveRecord::Migration
  def up
    add_column :results, :answers, :string
  end

  def down
    remove_column :results, :answers
  end
end
