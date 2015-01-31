class Answer2 < ActiveRecord::Base
  belongs_to :question
  validates :question, :text, presence: true
  validates_inclusion_of :is_right, in: [true, false]
end
