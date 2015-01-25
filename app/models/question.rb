class Question < ActiveRecord::Base
  belongs_to :toast
  has_many :answer1, dependent: :delete_all
  has_many :answer2, dependent: :delete_all
  has_many :answer3, dependent: :delete_all
  validates :question_type, :condition, :toast, presence: true

  def answers
    case self.question_type
    when 2
      self.answer2.shuffle
    when 3
      [self.answer3.where(side: false).shuffle, self.answer3.where(side: true).shuffle]
    else
      nil
    end
  end

end
