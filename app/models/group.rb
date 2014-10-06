class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :test_groups
  has_many :users, :through => :user_groups
  has_many :tests, :through => :test_groups

  def users_count
    UserGroup.where(:group_id => self.id).count
  end
end