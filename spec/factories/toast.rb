FactoryGirl.define do
  factory :toast do
    subject
    mark_system
    name Faker::Company.name
  end
end
