class Question < ActiveRecord::Base
  belongs_to :toast
  has_many :plurals, dependent: :delete_all
  has_many :associations, dependent: :delete_all
  accepts_nested_attributes_for :plurals, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :associations, reject_if: :all_blank, allow_destroy: true
  validates :question_type, inclusion: { in: [1, 2, 3] }
  validates :question_type, :text, :toast, presence: true

  def answers
    case question_type
    when 1
      is_right
    when 2
      plurals.shuffle
    when 3
      answers = associations
      left, right  = [], []
      answers.each do |answer|
        left.push answer.left_text unless answer.left_text.blank?
        right.push answer.right_text unless answer.right_text.blank?
      end
      [left.shuffle, right.shuffle]
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
