class Test < ActiveRecord::Base
  has_many :test_groups
  has_many :groups, :through => :test_groups

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

  def reg_group group_id
    if TestGroup.where(:test_id => self.id, :group_id => group_id).count == 0
      TestGroup.create!(:test_id => self.id, :group_id => group_id)
    end
  end

  def all_question_count
    Question.where(:test_id => self.id).count
  end

  def mark_systems
    MarkSystem.all
  end

  def questions
    questions = Question.select(:id).where(:test_id => self.id)
    qids = [] # question id's
    questions.each{ |e| qids.push e.id }
    qids.shuffle!
    if self.questions_count
      qids[0..self.questions_count-1]
    else
      qids
    end
  end

  def destroy
    Question.where(:test_id => self.id).delete_all
    super
  end

end
