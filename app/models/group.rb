class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :toasts

  validates :name, presence: true

  def foreign_users
    User.where.not(id: users)
  end

  def add_users(users)
    manager = InsertHelper.new(table_name: 'groups_users')
    manager.insert!(cols: [:group_id, :user_id], rows: users.map{|u| [id, u.id]})
  end
end
