class Toast < ActiveRecord::Base
  belongs_to :subject
  belongs_to :mark_system
  has_many :toast_groups, dependent: :delete_all
  has_many :groups, through: :toast_groups
  has_many :questions, dependent: :delete_all
  has_many :results, dependent: :delete_all
  validates :subject, :name, :mark_system, presence: true

  def self.find_toasts(subject, theme, group)
    toast = Toast.all
    toast = toast.where(subject_id: subject) unless subject.blank?
    toast = toast.where(theme: theme) unless theme.blank?
    toast = toast.where(group_id: group) unless group.blank?
    toast
  end

  def get_questions_list
    if self.questions_count
      questions.limit(self.questions_count).ids
    else
      questions.ids
    end
  end
end
