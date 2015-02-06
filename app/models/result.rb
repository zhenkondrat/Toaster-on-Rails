class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :toast
  validates :mark, :created_at, :user, :toast, presence: true
  validates :mark, numericality: { less_than_or_equal_to: 1 }

  def create_by_answers(user, questions, answers, toast)
    @toast = toast || questions.first.toast
    set_tariffs
    sum = 0
    questions.each do |question|
      case question.question_type
      when 1
        sum += @tariff1 if answers[question.id] == question.is_right
      when 2
        sum += @tariff2 if answer2_right? question, answers[question.id]
      when 3
        sum += @tariff3 if answer3_right? question, answers[question.id]
      end
    end
    self.user, self.mark, self.created_at = user, sum.to_f/(max_mark questions), DateTime.now
    self.save
  end

  def show_mark
    if self.toast.mark_system
      self.toast.mark_system.marks.where("percent <= #{self.mark*100}").order(id: :desc).first.presentation
    else
      self.mark.to_s
    end
  end

  private

  def set_tariffs
    @tariff1 = @toast.weight1 || 1
    @tariff2 = @toast.weight2 || 1
    @tariff3 = @toast.weight3 || 1
  end

  def max_mark(questions)
    sum = 0
    questions = Question.where("id IN (#{questions.join(', ')})")
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

  def answer2_right?(question, answer)
    solution = true
    question.answer2s.each do |supposition|
      unless supposition.is_right == answer[supposition.id]
        solution = false
      end
    end
    solution
  end

  def answer3_right?(question, answer)
    solution = true
    question.answer3s.each do |supposition|
      unless (supposition.left_text == answer[0]) && (supposition.right_text == answer[1])
        solution = false
      end
    end
    solution
  end
end
