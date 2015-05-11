class Subject < ActiveRecord::Base
  has_many :toasts, dependent: :delete_all
  has_and_belongs_to_many :users
  validates :name, presence: true
end
