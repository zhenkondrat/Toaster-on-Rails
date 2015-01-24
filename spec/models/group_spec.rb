require 'spec_helper'

describe Group do

  let(:group) {FactoryGirl.create(:group)}

  describe 'validates' do
    it { expect(group).to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { expect(group).to have_many(:user) }
    it { expect(group).to have_many(:toast) }
  end
end
