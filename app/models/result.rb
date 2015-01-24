class Result < ActiveRecord::Base

  def max_mark (questions)
    sum = 0
    questions = Question.where('id IN ('+questions.join(', ')+')')
    questions.each do |question|
      case question.question_type
      when 1
        sum += @tariff1
      when 2
        sum += @tariff2
      else
        sum += @tariff3
      end
    end
    sum
  end

  def answer2_right? (origin, answers)
    solution = true
    answers ||= []
    origin.each do |el|
      unless (el.is_right && (answers.include? el.id.to_s)) ||
          (!el.is_right && !(answers.include? el.id.to_s))
        solution = false
      end
    end
    solution
  end

  def answer3_right? (origin, left, right)
    solution = true
    origin.each do |e|
      if e.compare
        solution = false if left.key(right[e.id.to_s]) != e.compare.to_s
      end
    end
    solution
  end

  def create_by_answers (answers, questions, toast_id, user_id)
    @toast = Toast.find toast_id
    set_tariffs
    sum = 0
    self.toast_id = @toast.id

    if answers
      answers.each do |answer|
        question_id = answer[0]
        case answer[1] # question type
        when '1'
          origin = Answer1.where(:question_id => question_id).first
          sum += @tariff1 if origin.is_right.to_s == answer[2]
        when '2'
          origin = Answer2.where(:question_id => question_id)
          sum += @tariff2 if answer2_right? origin, answer[2]
        else
          origin = Answer3.where(:question_id => question_id, :side => 1)
          sum += @tariff3 if answer3_right? origin, answer[2][0], answer[2][1]
        end
      end
    end

    self.user_id = user_id
    self.mark = sum.to_f / (max_mark questions)
    self.created_at = DateTime.now
    self.save!
  end

  def set_tariffs
    @tariff1 = @toast.weight1 || 1
    @tariff2 = @toast.weight2 || 1
    @tariff3 = @toast.weight3 || 1
  end

  def get_toast
    Toast.find(self.toast_id)
  end

  def get_user_name
    User.find(self.user_id).login
  end

  def mark_presentation
    toast = Toast.find(self.toast_id)

    if toast.mark_system
      Mark.where("mark_system_id = #{toast.mark_system} AND percent <= #{self.mark*100}").order(id: :desc).first.presentation
    else
      result.mark.to_s
    end
  end

end
