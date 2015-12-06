class MarkSystem < ActiveRecord::Base
  has_many :marks, dependent: :delete_all
  has_many :toasts
  accepts_nested_attributes_for :marks, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validate  :min_mark_presence, :marks_uniq_percents, :min_count

  private

  def min_mark_presence
    unless marks.any? { |mark| mark.percent.zero? }
      errors.add(:marks, 'must have mark with percent eq 0')
    end
  end

  def marks_uniq_percents
    unless marks.map(&:percent).uniq.size == marks.size
      errors.add(:marks, 'must have unique percents')
    end
  end

  def min_count
    if marks.size < 2
      errors.add(:marks, 'count must be at least 2')
    end
  end
end
