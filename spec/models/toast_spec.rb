require 'spec_helper'

describe Toast do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:group) {FactoryGirl.create(:group)}

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

    describe '#find_toasts' do
      it 'should find toast by subject id' do
        expect(Toast.find_toasts({subject: subject.id})).to include toast
      end

      it 'should find toast by group id' do
        group.toast_groups.create(toast_id: toast.id)
        expect(Toast.find_toasts({group: group.id})).to include toast
      end

      it 'should find toast by name' do
        expect(Toast.find_toasts({name: toast.name})).to include toast
      end

      it 'should find toast with few parameters' do
        group.toast_groups.create(toast_id: toast.id)
        expect(Toast.find_toasts({subject: subject.id, group: group.id, name: toast.name})).to include toast
      end
    end

    describe '#get_questions_list' do
      pending 'there are no test here yet.'
    end
  end
end
