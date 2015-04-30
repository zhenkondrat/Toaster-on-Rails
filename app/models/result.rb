class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :toast
  validates :mark, :created_at, :user, :toast, presence: true
  validates :mark, numericality: { less_than_or_equal_to: 1 }

  def create_by_answers(questions, answers, toast = nil)
    @toast = toast || self.toast || questions.first.toast
    set_tariffs
    sum = 0
    questions.each do |question|
      case question.question_type
        when 1
        sum += @tariff1 if answers[question.id.to_s] == question.is_right.to_s
        when 2
        sum += @tariff2 if answer2_right? question, answers[question.id.to_s]
      when 3
        sum += @tariff3 if answer3_right? question, answers[question.id]
      end
    end
    self.mark, self.created_at, self.toast = sum.to_f/(max_mark questions), DateTime.now, @toast
    self.save!
    show_mark
  end

  def show_mark
    if toast.mark_system
      toast.mark_system.marks.where("percent <= #{self.mark_procent}").order(percent: :desc).first.presentation
    else
      mark.to_s
    end
  end


  def mark_procent
    mark*100
  end

  private

  def set_tariffs
    @tariff1 = @toast.weight1 || 1
    @tariff2 = @toast.weight2 || 1
    @tariff3 = @toast.weight3 || 1
  end

  def max_mark(questions)
    sum = 0
    questions = Question.where("id IN (#{questions.map{ |question| question.id.to_s }.join(', ')})")
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
      unless answer
        solution = false
        next
      end
      unless supposition.is_right == (answer[supposition.id.to_s] || false)
        solution = false
      end
    end
    solution
  end

  def answer3_right?(question, answer)
    solution = true
    question.answer3s.each do |supposition|
      if supposition.correct_pair?
        unless (supposition.left_text == answer[supposition.id][0]) && (supposition.right_text == answer[supposition.id][1])
          solution = false
        end
      end
    end
    solution
  end
end
