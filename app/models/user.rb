class User < ActiveRecord::Base
  include Roles
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :results, dependent: :delete_all
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :subjects
  has_and_belongs_to_many :toasts

  serialize :config, Hash

  validates :login, uniqueness: true

  validates_presence_of :last_name, unless: proc { |user| user.admin? }

  scope :admins, ->{ where role: ROLE_ADMIN }
  scope :teachers, ->{ where role: ROLE_TEACHER }
  scope :students, ->{ where role: ROLE_STUDENT }
  scope :users, ->{ where role: [ROLE_STUDENT, ROLE_TEACHER] }

  # TODO Refactoring with Arel
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
      ''
    else
      full_name = last_name
      full_name += " #{first_name[0]}." unless first_name.blank?
      full_name += " #{father_name[0]}." unless father_name.blank?
      full_name
    end
  end

  def available_toasts
    Toast.joins(groups: :users).where(users: {id: id})
  end

  def admin?
    role == ROLE_ADMIN
  end

  def teacher?
    role == ROLE_TEACHER
  end

  def student?
    role == ROLE_STUDENT
  end
end

