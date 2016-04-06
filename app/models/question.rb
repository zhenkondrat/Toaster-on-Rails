class Question < ActiveRecord::Base
  include QuestionTypes

  has_and_belongs_to_many :toasts
  has_many :plurals, dependent: :delete_all
  has_many :associations, dependent: :delete_all
  accepts_nested_attributes_for :plurals, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :associations, reject_if: :all_blank, allow_destroy: true
  validates :question_type, inclusion: { in: TYPE_LIST }
  validates :text, presence: true
  validate  :answers_presence

  def shuffle_answers
    case
    when plural? then manual_shuffle(plurals.to_a)
    when associative? then shuffle_associations
    else fail 'wrong question type to shuffle answers'
    end
  end

  def logical?
    question_type == TYPE_LOGICAL
  end

  def plural?
    question_type == TYPE_PLURAL
  end

  def associative?
    question_type == TYPE_ASSOCIATIVE
  end

  private

  def shuffle_associations
    left_side, right_side  = [], []
    associations.each do |answer|
      left_side.push answer.left_text if answer.left_text.present?
      right_side.push answer.right_text if answer.right_text.present?
    end
    [manual_shuffle(left_side), manual_shuffle(right_side)]
  end

  def manual_shuffle(array)
    initial = array.clone
    array.shuffle!
    initial == array ? array.insert(0, array.pop) : array
  end

  def answers_presence
    case
    when plural? then plurals_presence
    when associative? then associations_presence
    end
  end

  def plurals_presence
    errors.add(:plurals, 'answers must be present') unless plurals.present?
  end

  def associations_presence
    if associations.size < 2
      errors.add(:associations, 'answers count must be greater then 1')
    end
    full_pairs = associations.select{ |a| a.left_text.present? && a.right_text.present? }
    if full_pairs.size.zero?
      errors.add(:associations, 'answers must contain at least one full pair')
    end
  end
end
