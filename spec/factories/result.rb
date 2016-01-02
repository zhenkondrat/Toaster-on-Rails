FactoryGirl.define do
  factory :result do
    user
    toast
    hit Random.rand(1.0)
  end
end
