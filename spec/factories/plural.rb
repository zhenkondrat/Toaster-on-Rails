FactoryGirl.define do
  factory :plural do
    question
    text Faker::Lorem.word
    is_right Random.rand(2).zero?
  end
end
