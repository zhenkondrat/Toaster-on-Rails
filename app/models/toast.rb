class Toast < ActiveRecord::Base
  belongs_to :subject
  belongs_to :mark_system
  has_many :toast_groups, dependent: :delete_all
  has_many :groups, through: :toast_groups
  has_many :questions, dependent: :delete_all
  has_many :results, dependent: :delete_all
  validates :subject, :name, :mark_system, presence: true

  def self.find_toasts(params)
    toasts = Toast.all
    toasts = toasts.where(subject_id: params[:subject]) unless params[:subject].blank?
    toasts = toasts.where(name: params[:name]) unless params[:name].blank?
    toasts = toasts.joins(:toast_groups).where("toast_groups.group_id = #{params[:group]}") unless params[:group].blank?
    toasts
  end

  def get_questions_list
    if self.questions_count
      questions.limit(self.questions_count).ids.shuffle
    else
      questions.ids.shuffle
    end
  end
end
