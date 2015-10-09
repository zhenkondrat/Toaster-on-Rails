FactoryGirl.define do
  factory :plural do
    text Faker::Lorem.word
    is_right Random.rand(2).zero?
  end
end
