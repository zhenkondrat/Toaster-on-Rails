require 'spec_helper'

describe Subject do
  pending 'not all tests work correct'
  let(:subject) {FactoryGirl.create(:subject)}

  describe 'validates' do
    it { expect(subject).to validate_presence_of(:name) }
  end

  describe 'associations' do
    # it { expect(subject).to have_many(:tests).dependent(:delete_all) }
  end
end
