class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :subjects
  has_and_belongs_to_many :toasts

  validates :name, presence: true

  def foreign_users
    User.joins('LEFT JOIN user_groups ON user_groups.user_id = users.id').where("user_groups.group_id != #{id} OR user_groups.group_id IS null")
  end

  def out(user_id)
    UserGroup.find_by_user_id(user_id).delete
  end
end
