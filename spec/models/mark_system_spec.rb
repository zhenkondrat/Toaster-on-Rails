require 'spec_helper'

describe MarkSystem do

  let(:mark_system) {FactoryGirl.create(:mark_system)}

  describe 'validates' do
    it { expect(mark_system).to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { expect(mark_system).to have_many(:marks).dependent(:delete_all) }
  end
end
