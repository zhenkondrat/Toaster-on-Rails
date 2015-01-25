class Answer1 < ActiveRecord::Base
  belongs_to :question
  validates :question, presence: true
  validates_inclusion_of :is_right, in: [true, false], allow_nil: false
end
