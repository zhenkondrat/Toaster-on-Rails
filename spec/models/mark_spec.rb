require 'spec_helper'

describe Mark do

  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:mark) {FactoryGirl.create(:mark, mark_system: mark_system)}

  describe 'validates' do
    it { expect(mark).to validate_presence_of(:mark_system) }
    it { expect(mark).to validate_presence_of(:percent) }
    it { expect(mark).to validate_presence_of(:presentation) }
  end

  describe 'associations' do
    it { expect(mark).to belong_to(:mark_system) }
  end
end
