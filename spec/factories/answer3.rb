FactoryGirl.define do
  factory :answer3 do
    side Random.rand(2).zero?
    field Faker::Lorem.word
  end
end
