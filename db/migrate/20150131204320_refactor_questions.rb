class RefactorQuestions < ActiveRecord::Migration
  def up
    rename_column :questions, :condition, :text
  end

  def down
    rename_column :questions, :text, :condition
  end
end
