class InviteCode < ActiveRecord::Base
  validates :token, :role, presence: true
  validates :token, :role, uniqueness: true

  class << self
    include Roles

    def generate!(option = :all)
      case option
      when :all then {admin: generate(:admin), teacher: generate(:teacher), student: generate(:student)}
      when :admin, :teacher, :student then generate(option)
      else
        return unless option.class == Array
        option.map{ |role| {role => generate!(role)} }.reduce(:merge)
      end
    end

    def get(option = :all)
      case option
      when :all then {admin: take(:admin), teacher: take(:teacher), student: take(:student)}
      when :admin, :teacher, :student then take(option)
      else
        return unless option.class == Array
        option.map{ |role| {role => take(role)} }.reduce(:merge)
      end
    end

    private

    def generate(role)
      invite = nil
      InviteCode.find_by_role(role_name(role)).try(:delete)
      3.times do
        break if invite = InviteCode.create(token: (0...6).map{ (65 + rand(26)).chr }.join, role: role_name(role))
      end
      invite.errors.empty? ? invite.token : fail(%q|Can't generate token|)
    end

    def take(role)
      InviteCode.find_by_role(role_name(role)).try(:token) || generate(role)
    end
  end
end
