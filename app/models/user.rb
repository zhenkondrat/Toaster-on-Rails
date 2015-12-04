class User < ActiveRecord::Base
  include Roles
  devise :database_authenticatable, :registerable, :rememberable, :validatable, :confirmable
  has_many :results, dependent: :delete_all
  has_many :memberships, as: :member
  has_many :owned_groups, -> { where(memberships: { member_type: :owner }) },
           source: :group, through: :memberships
  has_many :joined_groups, -> { where(memberships: { member_type: :student }) },
           source: :group, through: :memberships
  has_and_belongs_to_many :subjects
  has_and_belongs_to_many :toasts

  serialize :config, Hash

  validates :login, uniqueness: true

  validates_presence_of :last_name, unless: ->(user) { user.admin? }

  scope :admins, ->{ where role: ROLE_ADMIN }
  scope :teachers, ->{ where role: ROLE_TEACHER }
  scope :students, ->{ where role: ROLE_STUDENT }
  scope :users, ->{ where role: [ROLE_STUDENT, ROLE_TEACHER] }

  # TODO Refactoring with Arel
  def self.search(search_filter)
    return User.all if search_filter.blank?
    search_filter = search_filter.gsub(/\s+/, ' ').strip.split
    query =
      case search_filter.size
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

  # TODO WTF is it still doing here?
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def full_name
    if last_name.present?
      full_name = last_name
      if first_name.present? && father_name.present?
        full_name += " #{first_name[0]}. #{father_name[0]}."
      end
      full_name
    else
      login
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
