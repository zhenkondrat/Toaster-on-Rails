class Toast < ActiveRecord::Base
  belongs_to :subject
  belongs_to :mark_system
  has_many :toast_groups, dependent: :delete_all
  has_many :groups, through: :toast_groups
  has_many :questions, dependent: :delete_all
  has_many :results, dependent: :delete_all
  validates :subject, :name, :mark_system, presence: true

  def self.search(params)
    toasts = Toast.all
    toasts = toasts.where(subject_id: params[:subject]) unless params[:subject].blank?
    toasts = toasts.where("name LIKE '%#{params[:name]}%'") unless params[:name].blank?
    toasts = toasts.joins(:toast_groups).where("toast_groups.group_id = #{params[:group]}") unless params[:group].blank?
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
