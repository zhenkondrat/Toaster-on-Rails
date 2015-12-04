class Membership < ActiveRecord::Base
  belongs_to :member, class_name: 'User'
  belongs_to :group

  validates :group, :member, presence: true
  validates :member_type, inclusion: { in: %w(student owner) }

  def type_owner?
    member_type == 'owner'
  end

  def type_student?
    member_type == 'student'
  end
end
