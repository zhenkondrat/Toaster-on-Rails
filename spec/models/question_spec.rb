require 'spec_helper'
require 'question_helper'

describe Question do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:question) {FactoryGirl.create(:question, toast: toast, question_type: 1)}

  describe 'validates' do
    it { expect(question).to validate_presence_of(:toast) }
    it { expect(question).to validate_presence_of(:text) }
    it { expect(question).to validate_presence_of(:question_type) }
    it { expect(question).to validate_inclusion_of(:question_type).in_array([1, 2, 3]) }
  end

  describe 'associations' do
    it { expect(question).to belong_to(:toast) }
    it { expect(question).to have_many(:plurals) }
    it { expect(question).to have_many(:plurals) }
  end

  describe 'methods' do
    describe '#answers' do
      it 'answer type 2 - many variants' do
        question.question_type = 2
        answers = create_answers question
        expect(question.answers.size).to eq (answers[:right_answers] + answers[:wrong_answers]).size
      end

      it 'answer type 3 - many to many variants' do
        question.question_type = 3
        answers = create_answers question
        expect(question.answers.size).to eq 2
        expect(question.answers[1].size).to eq answers[:correct_pairs].size
        expect(question.answers[0].size).to eq (answers[:correct_pairs] + answers[:single_records]).size
      end
    end
  end

end
