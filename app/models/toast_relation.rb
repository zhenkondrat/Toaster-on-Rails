class ToastRelation < ActiveRecord::Base
  belongs_to :parent, class_name: 'Toast'
  belongs_to :child, class_name: 'Toast'

  validates :percent, numericality: { greater_than: 0 }
  validates :percent, numericality: { less_than_or_equal_to: 100 }
end
