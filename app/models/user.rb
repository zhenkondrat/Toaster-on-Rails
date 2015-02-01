class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :user_groups, dependent: :delete_all
  has_many :groups, through: :user_groups
  has_many :results, dependent: :delete_all
  validates :login, uniqueness: true
  validate :have_user_surname?

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def full_name
    if self.last_name.blank?
      full_name = ''
    else
      full_name = self.last_name
      full_name += " #{self.first_name[0]}. #{self.father_name[0]}." unless self.first_name.blank? || self.father_name.blank?
    end

    full_name
  end

  private

  def have_user_surname?
    if self.last_name.blank? && !self.admin
      errors.add(:last_name, %q|Can't be empty for student(user)|)
    end
  end
end

