FactoryGirl.define do
  factory :answer1 do
    is_right Random.rand(2).zero?
  end
end
