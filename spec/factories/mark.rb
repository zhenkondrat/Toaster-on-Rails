FactoryGirl.define do
  factory :mark do
    mark_system
    percent Random.rand(100)
    presentation Faker::Lorem.word
  end
end
