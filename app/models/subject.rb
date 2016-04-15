class Subject < ActiveRecord::Base
  has_many :toasts, dependent: :delete_all
  has_and_belongs_to_many :teachers, class_name: 'User'
  validates :name, presence: true

  def self.search(user, search_filter)
    return user.subjects if search_filter.blank?
    user.subjects.where('name LIKE %?%', search_filter)
  end

  def foreign_teachers
    User.where.not(id: teachers).where(role: User::ROLE_TEACHER)
  end
end
