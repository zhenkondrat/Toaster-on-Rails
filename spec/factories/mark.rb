FactoryGirl.define do
  factory :mark do
    percent Random.rand(100)
    presentation Faker::Lorem.word
  end
end
