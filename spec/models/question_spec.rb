require 'spec_helper'

describe Question do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:question) {FactoryGirl.create(:question, toast: toast, question_type: 1)}

  describe 'validates' do
    it { expect(question).to validate_presence_of(:toast) }
    it { expect(question).to validate_presence_of(:condition) }
    it { expect(question).to validate_presence_of(:question_type) }
  end

  describe 'associations' do
    it { expect(question).to belong_to(:toast) }
    it { expect(question).to have_many(:answer2) }
    it { expect(question).to have_many(:answer3) }
  end

  describe 'methods' do
    describe '#answers' do
      it 'answer type 2 - many variants' do
        question.question_type = 2
        question.answer2.create(answer: Faker::Lorem.word, is_right: true)
        question.answer2.create(answer: Faker::Lorem.word, is_right: false)
        question.answer2.create(answer: Faker::Lorem.word, is_right: true)
        question.answer2.create(answer: Faker::Lorem.word, is_right: false)
        expect(question.answers.size).to eq 4
      end

      it 'answer type 3 - many to many variants' do
        question.question_type = 3
        question.answer3.create(field: Faker::Lorem.word, side: true)
        question.answer3.create(field: Faker::Lorem.word, side: false)
        question.answer3.create(field: Faker::Lorem.word, side: true)
        question.answer3.create(field: Faker::Lorem.word, side: false)
        question.answer3.create(field: Faker::Lorem.word, side: false)
        expect(question.answers.size).to eq 2
        expect(question.answers.first.size).to eq 3
        expect(question.answers.last.size).to eq 2
      end
    end
  end

end
