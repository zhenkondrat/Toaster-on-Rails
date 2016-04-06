class Mark < ActiveRecord::Base
  belongs_to :mark_system
  validates :mark_system, :presentation, :percent, presence: true
  validates :percent, numericality: { less_than_or_equal_to: 100 }
end
