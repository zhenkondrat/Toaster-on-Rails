class Answer3 < ActiveRecord::Base
  belongs_to :question
  belongs_to :answer3#, inverse_of: :answer3
  validates :question, :field, presence: true
  validates_inclusion_of :side, in: [true, false], allow_nil: false
end
