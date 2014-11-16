class InviteCode < ActiveRecord::Base
  validates :token, :date, :presence => true

  def self.generate!
    InviteCode.delete_all

    code_admin = InviteCode.new
    code_admin.token = (0...6).map { (65 + rand(26)).chr }.join
    code_admin.date = Date.today
    code_admin.admin = true
    code_admin.save!

    code_user = InviteCode.new
    code_user.token = (0...6).map { (65 + rand(26)).chr }.join
    while code_user.token == code_admin.token # if 'shit happens' :)
      code_user.token = (0...6).map { (65 + rand(26)).chr }.join
    end
    code_user.date = Date.today
    code_user.admin = false
    code_user.save!
  end

  def self.local
    admin = InviteCode.find_by_admin(true) ? InviteCode.find_by_admin(true).token : '<no token>'
    user = InviteCode.find_by_admin(false) ? InviteCode.find_by_admin(false).token : '<no token>'
    {:admin => admin, :user => user}
  end
end