require 'spec_helper'

describe MarkSystem do

  let(:mark_system) { create(:mark_system) }

  describe 'validates' do
    it { expect(mark_system).to validate_presence_of(:name) }

    describe 'marks' do
      let(:marks) { mark_system.marks }

      describe 'count' do
        context 'when less then 2' do
          before do
            marks.limit(marks.size-1).destroy_all
            marks.reload
          end

          it { expect(mark_system).to be_invalid }
        end

        context 'when greater or eq then 2' do
          it { expect(mark_system).to be_valid }
        end
      end

      describe 'percent uniqueness' do
        context %q|when they aren't unique| do
          before do
            mark_system.marks = (1..2).map { build(:mark, percent: 0) }
          end

          it { expect(mark_system).to be_invalid }
        end

        context %q|when they are unique| do
          it { expect(mark_system).to be_valid }
        end
      end

      describe 'min percent' do
        context 'when there are no mark with zero percent' do
          before do
            marks.where(percent: 0).delete_all
            marks.reload
          end

          it { expect(mark_system).to be_invalid }
        end

        context 'when there are mark with zero percent' do
          it { expect(mark_system).to be_valid }
        end
      end
    end
  end

  describe 'associations' do
    it { expect(mark_system).to have_many(:marks).dependent(:delete_all) }
    it { expect(mark_system).to accept_nested_attributes_for(:marks) }
  end
end
