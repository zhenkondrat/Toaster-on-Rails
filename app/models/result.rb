class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :toast

  validates :hit, :user, :toast, presence: true
  validates :hit, numericality: { less_than_or_equal_to: 1 }

  store_accessor :additional, :right, :wrong, :percent

  def calc_and_save_by_answers(questions)
    inc = ->(sum, tariff, right_count) { [sum + tariff, right_count + 1] }
    sum = 0
    right = 0

    questions.each do |question|
      case
      when question.logical? && logical_right?(question, answers)
        sum, right = inc.call(sum, weights['logical'], right)
      when question.plural? && plural_right?(question, answers[question.id.to_s])
        sum, right = inc.call(sum, weights['plural'], right)
      when question.associative? && associative_right?(question, answers[question.id.to_s])
        sum, right = inc.call(sum, weights['associative'], right)
      end
    end

    new_hit = sum.to_f / max_mark(questions)

    update!(
      hit: new_hit,
      answers: answers,
      right: right,
      wrong: questions.size - right,
      percent: (new_hit * 100).round
    )
    self
  end

  def presentation
    toast.mark_system
         .marks.where("percent <= #{hit * 100}")
         .order(percent: :desc)
         .first
         .presentation
  end

  private

  def weights
    toast.options['weights']
  end

  def max_mark(questions)
    questions.map{ |question| weights[question.question_type] }.sum
  end

  def logical_right?(question, answers)
    answers[question.id.to_s] == question.is_right.to_s
  end

  def plural_right?(question, answers = {})
    question.plurals.each do |supposition|
      if supposition.is_right
        return false unless answers[supposition.id.to_s].present?
      else
        return false unless answers[supposition.id.to_s].nil?
      end
    end
    true
  end

  def associative_right?(question, answers = {})
    question.associations.each do |supposition|
      next unless supposition.full_pair?
      answer = answers[supposition.id.to_s]
      unless answer == [supposition.left_text, supposition.right_text]
        return false
      end
    end
    true
  end
end
