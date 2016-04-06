# Answer type
class Plural < ActiveRecord::Base
  belongs_to :question
  validates :question, :text, presence: true
end
