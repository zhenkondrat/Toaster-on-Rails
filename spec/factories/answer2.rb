FactoryGirl.define do
  factory :answer2 do
    answer Faker::Lorem.word
    is_right Random.rand(2).zero?
  end
end
