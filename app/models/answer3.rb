class Answer3 < ActiveRecord::Base
  belongs_to :question
  validates :question, presence: true
  validate :some_side_present?

  def correct_pair?
    !left_text.blank? && !right_text.blank? ? true : false
  end

  private

  def some_side_present?
    if left_text.blank? && right_text.blank?
      errors.add(:sides, %q|Can't be empty in one time|)
    end
  end
end
