class Subject < ActiveRecord::Base
  has_many :toasts, dependent: :delete_all
  validates :name, presence: true
end
