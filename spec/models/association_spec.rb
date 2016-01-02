require 'spec_helper'

describe Association do
  let(:association) { create(:association) }

  describe 'associations' do
    it { expect(association).to belong_to(:question) }
  end

  describe 'validates' do
    it { expect(association).to validate_presence_of(:question) }

    context '#some_side_present?' do
      let(:invalid_association) { build(:association, left_text: nil, right_text: '') }
      let(:partial_association) { create(:partial_association) }

      it { expect(association).to be_valid }
      it { expect(partial_association).to be_valid }
      it { expect(invalid_association).to be_invalid }
    end
  end

  describe '#full_pair?' do
    let(:partial_association) { create(:partial_association) }

    it { expect(association.full_pair?).to eq true }
    it { expect(partial_association.full_pair?).to eq false }
  end
end
