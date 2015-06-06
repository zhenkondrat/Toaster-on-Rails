class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :subjects
  has_and_belongs_to_many :toasts

  validates :name, presence: true

  def foreign_users
    User.where.not(id: self.users)
  end
end
