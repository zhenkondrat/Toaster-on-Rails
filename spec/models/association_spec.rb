require 'spec_helper'

describe Association do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:question) {FactoryGirl.create(:question, toast: toast, question_type: 3)}
  let(:association) {FactoryGirl.create(:association, question: question)}

  describe 'associations' do
    it { expect(association).to belong_to(:question) }
  end

  describe 'validates' do
    it { expect(association).to validate_presence_of(:question) }

    context '#correct_pair?'
      it { expect(association.correct_pair?).to eq true }

      it 'should return false if it is not correct pair' do
        association.left_text = nil
        expect(association.correct_pair?).to eq false
      end
    end

    context '#some_side_present?' do
      it %q|two sides can't be empty in one time| do
        association.left_text = nil
        association.right_text = ''
        expect(association.valid?).to eq false
      end

      it %q|one side can be empty| do
        association.left_text = nil
        association.right_text = 'blabla'
        expect(association.valid?).to eq true
      end
    end
end
