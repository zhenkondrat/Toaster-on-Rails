class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :toast

  validates :mark, :created_at, :user, :toast, presence: true
  validates :mark, numericality: { less_than_or_equal_to: 1 }

  serialize :answers, Hash
  attr_accessor :tariff1, :tariff2, :tariff3

  def create_by_answers(questions, answers, custom_toast = nil)
    self.toast ||= custom_toast
    fail %q|Toast hasn't been set to result| unless toast
    set_tariffs
    inc = ->(sum, tariff, right_count) { [sum + tariff, right_count + 1] }
    sum = right = 0

    questions.each do |question|
      case question.question_type
      when 1
        sum, right = inc.call(sum, tariff1, right) if bool_right? question, answers
      when 2
        sum, right = inc.call(sum, tariff2, right) if plural_right? question, answers[question.id.to_s]
      when 3
        sum, right = inc.call(sum, tariff3, right) if associative_right? answers[question.id.to_s]
      end
    end

    max = max_mark questions
    self.save!(mark: sum.to_f / max, answers: answers)
    {mark: show_mark, right: right, wrong: questions.count-right, percent: (mark*100).round}
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
    self.tariff1 = toast.weight1 || 1
    self.tariff2 = toast.weight2 || 1
    self.tariff3 = toast.weight3 || 1
  end

  def max_mark(questions)
    sum = 0
    questions = Question.where(id: questions.map(&:id))
    questions.each do |question|
      sum +=
        case question.question_type
        when 1 then tariff1
        when 2 then tariff2
        when 3 then tariff3
        end
    end
    sum
  end

  def bool_right?(question, answers)
    answers[question.id.to_s] == question.is_right.to_s
  end

  def plural_right?(question, answer)
    solution = true
    question.plurals.each do |supposition|
      unless answer && supposition.is_right == (answer[supposition.id.to_s] || false)
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
