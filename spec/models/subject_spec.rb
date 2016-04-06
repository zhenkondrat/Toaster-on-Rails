require 'spec_helper'

describe Subject do
  let(:subject) { FactoryGirl.create(:subject) }

  describe 'validates' do
    it { expect(subject).to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { expect(subject).to have_many(:toasts).dependent(:delete_all) }
    it { expect(subject).to have_and_belong_to_many(:teachers).class_name('User') }
  end

  describe 'methods' do
    let!(:teacher) { create(:teacher) }
    let!(:foreign_teacher) { create(:teacher) }

    before { subject.teachers << teacher }

    describe '#foreign_teachers' do
      it { expect(subject.foreign_teachers).not_to include(teacher) }
      it { expect(subject.foreign_teachers).to include(foreign_teacher) }
    end
  end
end
