class InviteCode < ActiveRecord::Base
  validates :token, :date, presence: true
  validates :token, uniqueness: true

  def self.generate!
    old_admin_token = InviteCode.find_by_admin(:true) || InviteCode.new
    old_user_token = InviteCode.find_by_admin(:false) || InviteCode.new
    InviteCode.delete_all

    code_admin = InviteCode.new
    code_admin.token = (0...6).map { (65 + rand(26)).chr }.join
    code_admin.token = (0...6).map { (65 + rand(26)).chr }.join while old_admin_token.token == code_admin.token
    code_admin.date = Date.today
    code_admin.admin = true
    code_admin.save

    code_user = InviteCode.new
    code_user.token = (0...6).map { (65 + rand(26)).chr }.join
    while (code_user.token == code_admin.token) || (old_user_token.token == code_user.token)
      code_user.token = (0...6).map { (65 + rand(26)).chr }.join
    end
    code_user.date = Date.today
    code_user.admin = false
    code_user.save

    { admin: code_admin.token, user: code_user.token }
  end

  def self.local
    tokens = InviteCode.all
    if tokens.size != 2
      InviteCode.generate!
    else
      {
          admin: tokens[0].admin ? tokens[0].token : tokens[1].token,
          user: !tokens[1].admin ? tokens[1].token : tokens[0].token
      }
    end
  end
end