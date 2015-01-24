class Group < ActiveRecord::Base
  has_many :toast_group
  has_many :user_group
  has_many :user, through: :user_group
  has_many :toast, through: :toast_group

  validates :name, presence: true
end
