FactoryGirl.define do
  factory :answer2 do
    text Faker::Lorem.word
    is_right Random.rand(2).zero?
  end
end
