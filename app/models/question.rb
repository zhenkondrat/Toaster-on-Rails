class Question < ActiveRecord::Base
  def remove_answers
    case self.question_type
    when 1
      Answer1.where(:question_id => self.id).delete_all
    when 2
      Answer2.where(:question_id => self.id).delete_all
    when 3
      Answer3.where(:question_id => self.id).delete_all
    else
      nil
    end
  end

  def answer
    case self.question_type
      when 2
        Answer2.where(:question_id => self.id)
      when 3
        answers = Answer3.where(:question_id => self.id)
        [answers.where(side: false), answers.where(side: true)]
      else
        nil
    end
  end

end
