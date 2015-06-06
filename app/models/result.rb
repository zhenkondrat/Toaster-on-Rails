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
      sum += @tariff2 if plural_right? question, answers[question.id.to_s]
      when 3
        sum += @tariff3 if associative_right? answers[question.id.to_s]
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
    answer['right'].each_with_index{ |id, index| sulution = false unless answer['left'][index] == id }
    solution
  end
end
