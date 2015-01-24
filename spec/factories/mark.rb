FactoryGirl.define do
  factory :mark do
    percent Random.rand(1..99) / 100
    presentation Faker::Lorem.word
  end
end
