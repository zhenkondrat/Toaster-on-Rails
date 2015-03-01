class Subject < ActiveRecord::Base
  has_many :toasts, dependent: :delete_all
  validates :name, presence: true

  self.per_page = 10
end
