class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable
  has_many :groups, through: :user_groups
  def email_required?
    false
  end

end
