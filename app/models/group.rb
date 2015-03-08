class Group < ActiveRecord::Base
  has_many :toast_groups
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :toasts, through: :toast_groups

  validates :name, presence: true

  def foreign_users
    User.users.joins('LEFT JOIN user_groups ON user_groups.user_id = users.id').where("user_groups.group_id != #{id} OR user_groups.group_id IS null")
  end

  def out(user_id)
    UserGroup.find_by_user_id(user_id).delete
  end
end
