require 'spec_helper'

describe Group do

  let(:group) { FactoryGirl.create(:group) }

  describe 'validates' do
    it { expect(group).to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { expect(group).to have_and_belong_to_many(:users) }
    it { expect(group).to have_and_belong_to_many(:toasts) }
  end

  describe '#foreign_users' do
    it 'should select users that are not joined to group' do
      target = FactoryGirl.create(:user).reload
      group.users += (1..2).map{ FactoryGirl.create(:user) }
      expect(group.foreign_users).to eq [target]
    end
  end
end
