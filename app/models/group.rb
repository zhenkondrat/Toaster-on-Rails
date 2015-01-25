class Group < ActiveRecord::Base
  has_many :toast_groups
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :toasts, through: :toast_groups

  validates :name, presence: true
end
