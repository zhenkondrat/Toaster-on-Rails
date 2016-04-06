require 'spec_helper'

describe Mark do

  let(:mark) { create(:mark) }

  describe 'validates' do
    it { expect(mark).to validate_presence_of(:mark_system) }
    it { expect(mark).to validate_presence_of(:presentation) }

    context 'validate percent' do
      let(:invalid_mark) { build(:mark, percent: 101) }

      it { expect(mark).to validate_presence_of(:percent) }

      it { expect(invalid_mark).to be_invalid }
      it { expect(mark).to be_valid }
    end
  end

  describe 'associations' do
    it { expect(mark).to belong_to(:mark_system) }
  end
end
