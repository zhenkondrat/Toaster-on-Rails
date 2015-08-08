FactoryGirl.define do
  factory :association do
    left_text Faker::Lorem.word
    right_text Faker::Lorem.word
  end
end
