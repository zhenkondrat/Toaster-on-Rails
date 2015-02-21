require 'spec_helper'

describe Answer3 do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:question) {FactoryGirl.create(:question, toast: toast, question_type: 3)}
  let(:answer3) {FactoryGirl.create(:answer3, question: question)}

  describe 'associations' do
    it { expect(answer3).to belong_to(:question) }
  end

  describe 'validates' do
    it { expect(answer3).to validate_presence_of(:question) }

    context '#correct_pair?'
      it { expect(answer3.correct_pair?).to eq true }

      it 'should return false if it is not correct pair' do
        answer3.left_text = nil
        expect(answer3.correct_pair?).to eq false
      end
    end

    context '#some_side_present?' do
      it %q|two sides can't be empty in one time| do
        answer3.left_text = nil
        answer3.right_text = ''
        expect(answer3.valid?).to eq false
      end

      it %q|one side can be empty| do
        answer3.left_text = nil
        answer3.right_text = 'blabla'
        expect(answer3.valid?).to eq true
      end
    end
end
