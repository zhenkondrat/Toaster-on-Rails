class Test < ActiveRecord::Base
  def get_subject_name
    Subject.find(self.subject_id).subject_name
  end

  def self.find_tests subject, theme, group
    if subject.empty? && theme.empty? && group.empty?
      Test.all
    else
      query = if subject.empty?
                "'name' LIKE '"+theme+"%'"
              else
                "'name' LIKE '"+theme+"%' AND subject_id = "+subject
              end
      Test.all.where(query)
    end
  end

  def question_count
    Question.where(:test_id => self.id).count
  end
end
