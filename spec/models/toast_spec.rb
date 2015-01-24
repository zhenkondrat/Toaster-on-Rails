require 'spec_helper'

describe Toast do
  pending 'there are no test here yet.'
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}

  describe 'validates' do
    it { expect(toast).to validate_presence_of(:name) }
    it { expect(toast).to validate_presence_of(:mark_system) }
    it { expect(toast).to validate_presence_of(:subject) }
  end

  describe 'associations' do
    it { expect(toast).to have_many(:groups) }
    it { expect(toast).to have_many(:results) }
    it { expect(toast).to have_many(:questions) }
    it { expect(toast).to have_many(:toast_groups) }
    it { expect(toast).to belong_to(:mark_system) }
    it { expect(toast).to belong_to(:subject) }
  end

  describe 'methods' do
    context '#find_toasts' do

    end
  end
end
