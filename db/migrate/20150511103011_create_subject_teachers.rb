class CreateSubjectTeachers < ActiveRecord::Migration
  def up
    create_table :subjects_users, id: false do |t|
      t.integer :user_id
      t.integer :subject_id
    end
  end

  def down
    drop_table :subjects_users
  end
end
