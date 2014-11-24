class Group < ActiveRecord::Base
  has_many :user_groups, :foreign_key => :group_id, :dependent => :delete_all
  has_many :test_groups, :foreign_key => :group_id, :dependent => :delete_all

  def users_count
    UserGroup.where(:group_id => self.id).count
  end
end