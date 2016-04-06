require 'spec_helper'

describe User do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:teacher) { FactoryGirl.create(:teacher) }
  let(:student) { FactoryGirl.create(:student) }
  let(:last_name) { Faker::Name.last_name }
  let(:first_name) { Faker::Name.first_name }
  let(:father_name) { Faker::Name.first_name }

  describe 'validates' do
    it { expect(student).to validate_uniqueness_of(:login) }

    context 'presence of last_name' do
      context 'role admin' do
        before { admin.last_name = '' }

        it { expect(admin.valid?).to eq true }
      end

      context 'role teacher' do
        before { teacher.last_name = '' }

        it { expect(teacher.valid?).to eq false }
      end

      context 'role student' do
        before { student.last_name = '' }

        it { expect(student.valid?).to eq false }
      end
    end
  end

  describe 'associations' do
    it { expect(student).to have_many(:results).dependent(:delete_all) }
    it { expect(student).to have_many(:memberships) }
    it { expect(student).to have_many(:owned_groups) }
    it { expect(student).to have_many(:joined_groups) }
    it { expect(student).to have_and_belong_to_many(:subjects) }
  end

  describe '#full_name' do
    context %q|when user doesn't have any name| do
      before do
        student.attributes = {
          last_name: '',
          first_name: '',
          father_name: ''
        }
      end

      it { expect(student.full_name).to eq(student.login) }
    end

    context 'when user have some of name fields' do
      before do
        teacher.attributes = {
          last_name: last_name,
          first_name: first_name,
          father_name: ''
        }
      end

      it { expect(teacher.full_name).to eq(last_name) }
    end

    context 'when user have all name fields' do
      let(:expected_name) { "#{last_name} #{first_name[0]}. #{father_name[0]}." }
      before do
        teacher.attributes = {
          last_name: last_name,
          first_name: first_name,
          father_name: father_name
        }
      end

      it { expect(teacher.full_name).to eq(expected_name) }
    end
  end

  describe '#available_toasts' do
    let!(:toast) { create(:toast) }
    let!(:group) { create(:group) }
    let!(:another_toast) { create(:toast) }
    let!(:another_group) { create(:group) }

    before do
      group.toasts << toast
      another_group.toasts << another_toast
    end

    context 'when joined to toasts group' do
      before { student.joined_groups << group }

      it { expect(student.available_toasts).to include(toast) }
    end

    context %q|when isn't joined to toasts group| do
      before do
        student.joined_groups << another_group
        student.owned_groups << group
      end

      it { expect(student.available_toasts).not_to include(toast) }
    end
  end
end
