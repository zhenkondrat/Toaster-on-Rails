class Answer3 < ActiveRecord::Base
  belongs_to :question
  validates :question, :text_left, :text_right, presence: true
end
