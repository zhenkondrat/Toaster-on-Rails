class Plural < ActiveRecord::Base
  belongs_to :question
  validates :text, :question, presence: true
  validates_inclusion_of :is_right, in: [true, false]
end
