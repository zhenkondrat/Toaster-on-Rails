class ChangeQuestionTypeInQuestions < ActiveRecord::Migration
  include QuestionTypes

  def up
    change_table :questions do |t|
      t.change :question_type, :string
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, %q|Nooo.. You just shouldn't|
  end
end
