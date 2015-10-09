class Association < ActiveRecord::Base
  belongs_to :question

  validates :question, presence: true
  validate :some_side_present?

  def correct_pair?
    left_text.present? || right_text.present?
  end

  private

  def some_side_present?
    errors.add(:sides, %q|Can't be empty in one time|) if left_text.blank? && right_text.blank?
  end
end
