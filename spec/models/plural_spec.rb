require 'spec_helper'

describe Plural do
  let(:plural) { create(:plural) }

  describe 'validates' do
    it { expect(plural).to validate_presence_of(:question) }
    it { expect(plural).to validate_presence_of(:text) }
  end

  describe 'associations' do
    it { expect(plural).to belong_to(:question) }
  end
end
