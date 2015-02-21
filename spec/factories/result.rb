FactoryGirl.define do
  factory :result do
    created_at Faker::Time.between(2.days.ago, Time.now)
    mark Random.rand(1.0)
  end
end
