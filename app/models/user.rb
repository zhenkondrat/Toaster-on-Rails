class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable

  def email_required?
    false
  end

end
