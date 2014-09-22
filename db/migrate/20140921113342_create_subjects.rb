class CreateSubjects < ActiveRecord::Migration
  def up
    create_table(:subjects) do |t|
      t.string :subject_name
    end
  end

  def down
    drop_table(:subjects)
  end
end
