class RefactorAnswer3s < ActiveRecord::Migration
  def up
    rename_column :answer3s, :field, :left_text
    remove_column :answer3s, :side
    remove_column :answer3s, :answer3_id
    change_column :answer3s, :left_text, :string
    add_column :answer3s, :right_text, :string
  end

  def down
    remove_column :answer3s, :right_text
    rename_column :answer3s, :left_text, :field
    add_column :answer3s, :side, :boolean
    add_column :answer3s, :answer3_id, :integer
  end
end
