FactoryGirl.define do
  factory :question do
    text Faker::Lorem.paragraph
  end
end
