class Question < ActiveRecord::Base
  def remove_answers
    case self.question_type
    when 1
      Answer1.where(:question_id => self.id).delete_all
    when 2
      Answer2.where(:question_id => self.id).delete_all
    when 3
      Answer3.where(:question_id => self.id).delete_all
    end
  end
end
