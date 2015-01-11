class Group < ActiveRecord::Base
  has_many :test_group
  has_many :user_group
  has_many :user, through: :user_group
  has_many :test, through: :test_group

  validates :name, presence: true
end