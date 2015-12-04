# Answer type
class Association < ActiveRecord::Base
  belongs_to :question

  validate :some_side_present?
  validates :question, presence: true

  def full_pair?
    left_text.present? && right_text.present?
  end

  private

  def some_side_present?
    if left_text.blank? && right_text.blank?
      errors.add(:sides, %q|Can't be empty in one time|)
    end
  end
end
