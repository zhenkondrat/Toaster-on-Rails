class Subject < ActiveRecord::Base
  has_many :toasts, dependent: :delete_all
  has_and_belongs_to_many :teachers, class_name: 'User'
  validates :name, presence: true

  def foreign_teachers
    User.where.not(id: self.teachers).where(role: User::ROLE_TEACHER)
  end
end
