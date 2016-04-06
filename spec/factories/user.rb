include Roles

FactoryGirl.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    sequence(:login) { Faker::Internet.user_name }
    password Faker::Lorem.characters(5)
    last_name Faker::Name.last_name
  end

  factory :admin, parent: :user do
    role role_name(:admin)
  end

  factory :teacher, parent: :user do
    role role_name(:teacher)
  end

  factory :student, parent: :user do
    role role_name(:student)
  end
end
