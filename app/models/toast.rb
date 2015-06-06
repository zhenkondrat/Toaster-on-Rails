class Toast < ActiveRecord::Base
  belongs_to :subject
  belongs_to :mark_system
  has_and_belongs_to_many :groups
  has_many :questions, dependent: :delete_all
  has_many :results, dependent: :delete_all
  validates :subject, :name, :mark_system, presence: true

  def self.search(user, options: {})
    toasts = user.admin? ? Toast.all : Toast.where(subject_id: user.subject_ids)
    toasts = toasts.where(subject_id: options[:subject]) unless options[:subject].blank?
    toasts = toasts.where("name LIKE '%#{options[:name]}%'") unless options[:name].blank?
    toasts = toasts.joins(:toast_groups).where("toast_groups.group_id = #{options[:group]}") unless options[:group].blank?
    toasts
  end

  def get_questions_list
    (questions_count.nil? ? questions.ids : questions.limit(questions_count).ids).try(:shuffle)
  end

  def foreign_groups
    Group.where.not(id: groups)
  end
end
