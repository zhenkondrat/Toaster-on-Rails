class RenameModelsToAnswers < ActiveRecord::Migration
  def up
    rename_table :answer2s, :plurals
    rename_table :answer3s, :associations
  end

  def down
    rename_table :plurals, :answer2s
    rename_table :associations, :answer3s
  end
end
