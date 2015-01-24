class Toast < ActiveRecord::Base
  belongs_to :subject
  belongs_to :mark_system
  has_many :toast_groups, dependent: :delete_all
  has_many :questions, dependent: :delete_all
  validates :subject, :name, :mark_system, presence: true

  def self.find_toasts(subject, theme, group)
    if subject.empty? && theme.empty? && group.empty?
      Toast.all
    else
      query = if subject.empty?
                "'name' LIKE '#{theme}%'"
              else
                "'name' LIKE '#{theme}%' AND subject_id = #{subject}"
              end
      Toast.all.where(query)
    end
  end

  def reg_group(group_id)
    if ToastGroup.where(toast_id: self.id, group_id: group_id).count == 0
      ToastGroup.create!(toast_id: self.id, group_id: group_id)
    end
  end

  def all_question_count
    Question.where(:toast_id => self.id).count
  end

  def mark_systems
    MarkSystem.all
  end

  def questions
    questions = Question.select(:id).where(:toast_id => self.id)
    qids = [] # question id's
    questions.each{ |e| qids.push e.id }
    qids.shuffle!
    if self.questions_count
      qids[0..self.questions_count-1]
    else
      qids
    end
  end

end
