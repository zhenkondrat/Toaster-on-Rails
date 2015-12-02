class ChangeToasts < ActiveRecord::Migration
  def up
    change_table :toasts do |t|
      t.jsonb :options, default: {weights: {logical: 1, plural: 1, association: 1}}
    end

    Toast.all.each do |toast|
      toast.options = {
        weights: {
          logical: toast.weight1,
          plural: toast.weight2,
          associative: toast.weight3
        },
        questions_count: toast.questions_count,
        answer_time_limit: toast.question_time,
        learning_flag: toast.learning_flag
      }

      toast.save(validate: false)
    end

    remove_columns :toasts, :weight1, :weight2, :weight3, :questions_count,
                   :question_time, :learning_flag
  end

  def down
    change_table :toasts do |t|
      t.integer :weight1
      t.integer :weight2
      t.integer :weight3
      t.integer :questions_count
      t.integer :question_time
      t.integer :learning_flag
    end

    Toast.all.each do |toast|
      weights = toast.options['weights']
      toast.assign_attributes(
        weight1: weights['logical'],
        weight2: weights['plural'],
        weight3: weights['associative'],
        questions_count: toast.options['questions_count'],
        question_time: toast.options['answer_time_limit'],
        learning_flag: toast.options['learning_flag']
      )
      toast.save(validate: false)
    end

    remove_column :toasts, :options
  end
end
