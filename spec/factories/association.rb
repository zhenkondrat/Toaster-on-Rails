FactoryGirl.define do
  factory :association do
    question
    left_text { Faker::Lorem.word }
    right_text { Faker::Lorem.sentence(2) }
  end

  factory :partial_association, parent: :association do
    left_text nil
  end
end
