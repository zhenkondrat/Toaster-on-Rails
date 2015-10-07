class Toast < ActiveRecord::Base
  belongs_to :subject
  belongs_to :mark_system
  has_and_belongs_to_many :groups

  has_many :questions, dependent: :delete_all # TODO not for all cases
  has_many :results, dependent: :delete_all

  has_many :parent_relations, class_name: 'ToastRelation', foreign_key: 'parent_id', dependent: :destroy
  has_many :child_relations, class_name: 'ToastRelation', foreign_key: 'child_id', dependent: :destroy
  has_many :children, class_name: 'Toast', through: :parent_relations
  has_many :parents, class_name: 'Toast', through: :child_relations

  validates :subject, :name, :mark_system, presence: true
  validates :questions_count, numericality: { greater_than: 0 }, unless: proc { questions_count.nil? }

  attr_accessor :parser_file

  def self.search(user, subject_id: nil, name: nil, group_id: nil)
    toasts = user.admin? ? Toast.all : Toast.where(subject_id: user.subject_ids)
    toasts = toasts.where(subject_id: subject_id) unless subject_id.nil?
    toasts = toasts.where("toasts.name LIKE '%#{name}%'") unless name.nil?
    toasts = toasts.joins(:groups).where(groups: {id: group_id}) unless group_id.nil?
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

  private

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
