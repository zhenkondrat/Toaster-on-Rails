class Toast < ActiveRecord::Base
  belongs_to :subject
  belongs_to :mark_system
  has_and_belongs_to_many :groups
  has_many :questions, dependent: :delete_all
  has_many :results, dependent: :delete_all

  has_many :parent_relations, class_name: 'ToastRelation', foreign_key: 'parent_id', dependent: :destroy
  has_many :child_relations, class_name: 'ToastRelation', foreign_key: 'child_id', dependent: :destroy
  has_many :children, class_name: 'Toast', through: :parent_relations
  has_many :parents, class_name: 'Toast', through: :child_relations

  validates :subject, :name, :mark_system, presence: true

  def self.search(user, options: {})
    toasts = user.admin? ? Toast.all : Toast.where(subject_id: user.subject_ids)
    toasts = toasts.where(subject_id: options[:subject]) unless options[:subject].blank?
    toasts = toasts.where("name LIKE '%#{options[:name]}%'") unless options[:name].blank?
    toasts = toasts.joins(:toast_groups).where("toast_groups.group_id = #{options[:group]}") unless options[:group].blank?
    toasts
  end

  def get_questions_list
    if questions_count.nil?
      all_questions_list.shuffle
    else
      all_questions_list.shuffle[0..questions_count-1]
    end
  end

  def foreign_groups
    Group.where.not(id: groups)
  end

  def foreign_toasts
    ids = [*parents.ids, *all_children, id]
    Toast.where.not(id: ids).where(subject_id: subject_id)
  end

  def all_children
    ids = children.ids
    children.each{ |child| ids.push child.all_children }
    ids
  end

  def all_questions_list
    list = questions.ids
    children.each{ |child| list = [*list, *child.all_questions_list] }
    list
  end
end
