FactoryGirl.define do
  factory :question, aliases: [:logical_question] do
    question_type :logical
    text Faker::Lorem.paragraph
  end

  factory :plural_question, parent: :question do
    question_type :plural

    before(:create) do |question, _|
      plurals_attributes = (0..2).map { build(:plural, question: question) }
      question.assign_attributes(plurals: plurals_attributes)
    end
  end

  factory :associative_question, parent: :question do
    question_type :associative

    before(:create) do |question, _|
      associations_attributes = [
        build(:association, question: question),
        build(:partial_association, question: question)
      ]
      question.assign_attributes(associations: associations_attributes)
    end
  end
end
