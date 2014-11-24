class Question < ActiveRecord::Base
  has_many :answer1, :foreign_key => :question_id, :dependent => :delete_all
  has_many :answer2, :foreign_key => :question_id, :dependent => :delete_all
  has_many :answer3, :foreign_key => :question_id, :dependent => :delete_all

  def answer
    case self.question_type
    when 2
      Answer2.where(:question_id => self.id).shuffle
    when 3
      answers = Answer3.where(:question_id => self.id)
      [answers.where(side: false).shuffle, answers.where(side: true).shuffle]
    else
      nil
    end
  end

end
