class Test < ActiveRecord::Base
  def get_subject_name
    Subject.find(self.subject_id).subject_name
  end
end
