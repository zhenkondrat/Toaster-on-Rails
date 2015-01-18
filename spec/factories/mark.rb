FactoryGirl.define do
  factory :mark do
    mark_system nil
    percent Random.rand(1..99) / 100
    presentation Faker::Lorem.word
  end
end
