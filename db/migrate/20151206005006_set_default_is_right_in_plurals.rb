class SetDefaultIsRightInPlurals < ActiveRecord::Migration
  def up
    change_column_default :plurals, :is_right, false
  end
end
