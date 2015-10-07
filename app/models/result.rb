class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :toast
  validates :mark, :created_at, :user, :toast, presence: true
  validates :mark, numericality: { less_than_or_equal_to: 1 }
  serialize :answers, Hash

  def create_by_answers(questions, answers, toast = nil)
    @toast = toast || self.toast || questions.first.toast # TODO not for all cases '..first.toast'
    set_tariffs
    sum = right = 0
    questions.each do |question|
      case question.question_type
      when 1
        if answers[question.id.to_s] == question.is_right.to_s
          sum += @tariff1
          right += 1
        end
      when 2
        if plural_right? question, answers[question.id.to_s]
          sum += @tariff2
          right += 1
        end
      when 3
        if associative_right? answers[question.id.to_s]
          sum += @tariff3
          right += 1
        end
      end
    end
    max = max_mark questions
    update(mark: sum.to_f / max, toast: @toast, answers: answers, created_at: DateTime.now)
    {mark: show_mark, right: right, wrong: questions.count-right, percent: (mark*100).round(0)}
  end

  def show_mark
    if toast.mark_system
      toast.mark_system.marks.where("percent <= #{mark * 100}").order(percent: :desc).first.presentation
    else
      mark.to_s
    end
  end

  private

  def set_tariffs
    byebug
    @tariff1 = @toast.weight1 || 1
    @tariff2 = @toast.weight2 || 1
    @tariff3 = @toast.weight3 || 1
  end

  def max_mark(questions)
    sum = 0
    questions = Question.where("id IN (#{questions.map{ |question| question.id.to_s }.join(', ')})")
    questions.each do |question|
      sum +=
        case question.question_type
        when 1
          @tariff1
        when 2
          @tariff2
        when 3
          @tariff3
        end
    end
    sum
  end

  def plural_right?(question, answer)
    solution = true
    question.plurals.each do |supposition|
      if answer
        solution = false unless supposition.is_right == (answer[supposition.id.to_s] || false)
      else
        solution = false
      end
    end
    solution
  end

  def associative_right?(answer)
    solution = true
    answer['right'].each_with_index{ |id, index| solution = false unless answer['left'][index] == id } if answer
    solution
  end
end
