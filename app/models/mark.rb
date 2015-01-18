class Mark < ActiveRecord::Base
  belongs_to :mark_system
  validates :mark_system, :presentation, :percent, presence: true
end
