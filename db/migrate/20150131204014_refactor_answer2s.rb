class RefactorAnswer2s < ActiveRecord::Migration
  def up
    rename_column :answer2s, :answer, :text
  end

  def down
    rename_column :answer2s, :text, :answer
  end
end
