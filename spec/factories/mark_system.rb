FactoryGirl.define do
  factory :mark_system do
    name Faker::Lorem.word

    before(:create) do |mark_system, _|
      marks_attributes =
        (0..3).map do |percent|
          build(
            :mark,
            mark_system: mark_system,
            percent: percent*10
          )
        end
      mark_system.assign_attributes(marks: marks_attributes)
    end
  end
end
