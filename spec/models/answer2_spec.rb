require 'spec_helper'

describe Answer2 do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:question) {FactoryGirl.create(:question, toast: toast, question_type: 2)}
  let(:answer2) {FactoryGirl.create(:answer2, question: question)}

  describe 'validates' do
    it { expect(answer2).to validate_presence_of(:question) }
    it { expect(answer2).to validate_presence_of(:text) }
    it { expect(answer2).to validate_inclusion_of(:is_right).in_array([true, false]) }
  end

  describe 'associations' do
    it { expect(answer2).to belong_to(:question) }
  end
end
