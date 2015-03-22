class Question < ActiveRecord::Base
  belongs_to :toast
  has_many :answer2s, dependent: :delete_all
  has_many :answer3s, dependent: :delete_all
  validates :question_type, inclusion: { in: [1, 2, 3] }
  validates :question_type, :text, :toast, presence: true

  def answers
    case question_type
    when 2
      return answer2s.shuffle
    when 3
      answers = answer3s
      left = []; right = []
      answers.each do |answer|
        left.push answer.left_text unless answer.left_text.blank?
        right.push answer.right_text unless answer.right_text.blank?
      end
      return [left.shuffle, right.shuffle]
    else
      return is_right
    end
  end

  def no_type?
    question_type.nil?
  end

  def logical?
    question_type == 1
  end

  def plural?
    question_type == 2
  end

  def associative?
    question_type == 3
  end
end
