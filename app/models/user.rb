class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :user_groups, dependent: :delete_all
  has_many :groups, through: :user_groups
  has_many :results, dependent: :delete_all
  validates :login, uniqueness: true
  validate :have_user_surname?

  self.per_page = 30

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

  private

  def have_user_surname?
    if last_name.blank? && !admin?
      errors.add(:last_name, %q|Can't be empty for student(user)|)
    end
  end
end

