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
    if questions_count
      questions.limit(questions_count).ids.shuffle
    else
      questions.ids.shuffle
    end
  end

  def foreign_groups
    Group.joins('LEFT JOIN toast_groups ON toast_groups.group_id = groups.id').where("toast_groups.toast_id != #{id} OR toast_groups.group_id IS null")
  end
end
