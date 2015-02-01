class Question < ActiveRecord::Base
  belongs_to :toast
  has_many :answer2s, dependent: :delete_all
  has_many :answer3s, dependent: :delete_all
  validates :question_type, :text, :toast, presence: true

  def answers
    case self.question_type
    when 2
      return self.answer2s.shuffle
    when 3
      answers = self.answer3s
      left = []; right = []
      answers.each do |answer|
        left.push answer.left_text unless answer.left_text.blank?
        right.push answer.right_text unless answer.right_text.blank?
      end
      return [left.shuffle, right.shuffle]
    else
      return self.is_right
    end
  end

end
