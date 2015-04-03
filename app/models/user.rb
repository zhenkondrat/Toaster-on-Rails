class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :user_groups, dependent: :delete_all
  has_many :groups, through: :user_groups
  has_many :results, dependent: :delete_all
  validates :login, uniqueness: true
  validate :have_user_surname?
  serialize :config, Hash

  def self.search(search_filter)
    return User.all unless search_filter.present?
    search_filter = search_filter.gsub(/\s+/, ' ').strip.split
    query = case search_filter.size
            when 1
              "last_name LIKE '%#{search_filter.first}%' OR login LIKE '%#{search_filter.first}%'"
            when 2
              "last_name LIKE '%#{search_filter.first}%' AND first_name LIKE '%#{search_filter.last}%'"
            when 3
              "last_name LIKE '%#{search_filter.first}%' AND first_name LIKE '%#{search_filter[1]}%' AND father_name LIKE '%#{search_filter.last}%'"
            else
              'true'
            end
    User.where(query)
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def full_name
    if last_name.blank?
      full_name = ''
    else
      full_name = last_name
      full_name += " #{first_name[0]}. #{father_name[0]}." unless first_name.blank? || father_name.blank?
    end

    full_name
  end

  def admin?
    admin
  end

  class << self
    def admins
      User.where(admin: true)
    end

    def users
      User.where(admin: false)
    end
  end

  private

  def have_user_surname?
    if last_name.blank? && !admin?
      errors.add(:last_name, %q|Can't be empty for student(user)|)
    end
  end
end

