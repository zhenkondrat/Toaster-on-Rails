class AddToastsQuestionsTable < ActiveRecord::Migration
  def up
    create_join_table :toasts, :questions
    remove_column :questions, :toast_id
  end

  def down
    drop_join_table :toasts, :questions
    add_column :questions, :toast_id, :integer
  end
end
