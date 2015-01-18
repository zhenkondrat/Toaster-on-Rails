class RenameSubjectNameInSubjects < ActiveRecord::Migration
  def up
    rename_column :subjects, :subject_name, :name
  end

  def down
    rename_column :subjects, :name, :subject_name
  end
end
