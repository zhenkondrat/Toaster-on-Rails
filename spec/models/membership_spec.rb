require 'spec_helper'

describe Membership do
  let(:membership) { create(:membership) }

  describe 'validates' do
    it { expect(membership).to validate_presence_of(:group) }
    it { expect(membership).to validate_presence_of(:member) }
    it { expect(membership).to validate_inclusion_of(:member_type).in_array(%w(student owner)) }
  end

  describe 'associations' do
    it { expect(membership).to belong_to(:group) }
    it { expect(membership).to belong_to(:member).class_name('User') }
  end

  describe 'methods' do
    let(:owner_membership) { create(:membership, member_type: :owner) }
    describe '#type_student?' do
      it { expect(membership.type_student?).to eq true }
      it { expect(owner_membership.type_student?).to eq false }
    end

    describe '#type_owner?' do
      it { expect(membership.type_owner?).to eq false }
      it { expect(owner_membership.type_owner?).to eq true }
    end
  end
end
