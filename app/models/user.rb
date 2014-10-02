class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable
  has_many :groups, through: :user_groups
  def email_required?
    false
  end
  def registrations
    groups_id = ""
    groups = UserGroup.where('user_id' => self.id).select(:group_id)
    groups.each{ |g|
      groups_id += g.group_id.to_s+", "
    }
    groups_id.empty? ? nil : Group.where('id IN ('+groups_id.chop.chop+')')
  end
end
