require 'spec_helper'

describe Answer1 do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:question) {FactoryGirl.create(:question, toast: toast, question_type: 1)}
  let(:answer1) {FactoryGirl.create(:answer1, question: question)}

  describe 'validates' do
    it { expect(answer1).to validate_presence_of(:question) }
    it { expect(answer1).to validate_inclusion_of(:is_right).in_array([true, false]).allow_nil(false) }
  end

  describe 'associations' do
    it { expect(answer1).to belong_to(:question) }
  end
end
