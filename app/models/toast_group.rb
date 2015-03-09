class ToastGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :toast

  validates_uniqueness_of :group_id, scope: :toast_id
end
