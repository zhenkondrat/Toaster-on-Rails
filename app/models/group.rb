class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  def users_count
    UserGroup.where(:group_id => self.id).count
  end
end