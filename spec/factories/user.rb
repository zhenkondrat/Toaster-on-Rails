FactoryGirl.define do
  factory :user do
    sequence(:login) { Faker::Internet.user_name }
    password Faker::Lorem.characters(5)
    last_name Faker::Name.last_name
  end
end
