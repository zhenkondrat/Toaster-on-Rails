require 'spec_helper'

describe Answer3 do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:question) {FactoryGirl.create(:question, toast: toast, question_type: 3)}
  let(:answer3) {FactoryGirl.create(:answer3, question: question)}

  describe 'validates' do
    it { expect(answer3).to validate_presence_of(:question) }
    it { expect(answer3).to validate_presence_of(:field) }
    it { expect(answer3).to validate_inclusion_of(:side).in_array([true, false]).allow_nil(false) }
  end

  describe 'associations' do
    it { expect(answer3).to belong_to(:question) }
    pending 'there are not all test here yet.'
    # it { expect(answer3).to belong_to(:answer3).inverse_of(:answer3) }
  end
end
