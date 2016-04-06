FactoryGirl.define do
  factory :membership do
    group
    member { create(:user) }
    member_type :student
  end
end
