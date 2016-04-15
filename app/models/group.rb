class Group < ActiveRecord::Base
  has_many :memberships
  has_many :owners, -> { where(memberships: { member_type: :owner }) },
           source: :member, through: :memberships, class_name: 'User'
  has_many :students, -> { where(memberships: { member_type: :student }) },
           source: :member, through: :memberships, class_name: 'User'
  has_and_belongs_to_many :toasts

  validates :name, presence: true

  def self.search(user, search_filter)
    return user.owned_groups if search_filter.blank?
    user.owned_groups.where('name LIKE %?%', search_filter)
  end

  def foreign_users
    User.where.not(id: students).where.not(id: owners)
  end

  def change_students(user_ids)
    user_ids = user_ids.map(&:id) if user_ids.first.kind_of? User
    return if user_ids.sort == students.ids.sort
    remove_students(students.ids - user_ids)
    add_students(user_ids - students.ids)
  end

  private

  def remove_students(user_ids)
    memberships.where(member_id: user_ids, member_type: :student).delete_all
  end

  def add_students(user_ids)
    helper = InsertHelper.new(klass: Membership)
    rows = user_ids.map{ |user_id| [id, user_id] }
    helper.insert!(cols: [:group_id, :member_id], rows: rows, set_timestamps: true)
  end
end
