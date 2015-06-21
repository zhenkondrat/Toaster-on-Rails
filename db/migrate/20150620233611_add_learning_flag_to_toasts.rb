class AddLearningFlagToToasts < ActiveRecord::Migration
  def up
    add_column :toasts, :learning_flag, :boolean
  end

  def down
    remove_column :toasts, :learning_flag
  end
end
