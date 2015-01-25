FactoryGirl.define do
  factory :question do
    condition Faker::Lorem.paragraph
  end
end
