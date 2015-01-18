class Subject < ActiveRecord::Base
  has_many :tests, dependent: :delete_all
  validates :name, presence: true
end
