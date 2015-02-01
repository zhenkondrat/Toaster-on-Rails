require 'spec_helper'

describe Question do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:question) {FactoryGirl.create(:question, toast: toast, question_type: 1)}

  describe 'validates' do
    it { expect(question).to validate_presence_of(:toast) }
    it { expect(question).to validate_presence_of(:text) }
    it { expect(question).to validate_presence_of(:question_type) }
  end

  describe 'associations' do
    it { expect(question).to belong_to(:toast) }
    it { expect(question).to have_many(:answer2s) }
    it { expect(question).to have_many(:answer3s) }
  end

  describe 'methods' do
    describe '#answers' do
      it 'answer type 2 - many variants' do
        question.question_type = 2
        question.answer2s.create(text: Faker::Lorem.word, is_right: true)
        question.answer2s.create(text: Faker::Lorem.word, is_right: false)
        question.answer2s.create(text: Faker::Lorem.word, is_right: true)
        question.answer2s.create(text: Faker::Lorem.word, is_right: false)
        expect(question.answers.size).to eq 4
      end

      it 'answer type 3 - many to many variants' do
        question.question_type = 3
        5.times { question.answer3s.create(left_text: Faker::Lorem.word, right_text: Faker::Lorem.word) }
        3.times { question.answer3s.create(left_text: Faker::Lorem.word, right_text: nil) }
        expect(question.answers.size).to eq 2
        expect(question.answers[1].size).to eq 5
        expect(question.answers[0].size).to eq 8
      end
    end
  end

end
