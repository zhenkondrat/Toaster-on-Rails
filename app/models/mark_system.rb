class MarkSystem < ActiveRecord::Base
  has_many :marks, dependent: :delete_all
  validates :name, presence: true

  self.per_page = 10
end
