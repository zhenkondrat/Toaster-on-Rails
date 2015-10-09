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

    context 'student(user) must have last_name:' do
      it 'admin can be without any names' do
        admin.last_name = ''
        expect(admin.valid?).to eq true
      end

      it %q|user can't be without last_name| do
        teacher.last_name = ''
        expect(teacher.valid?).to eq false
      end

      it %q|user is valid with last_name| do
        student.last_name = last_name
        expect(student.valid?).to eq true
      end
    end
  end

  describe 'associations' do
    it { expect(student).to have_and_belong_to_many(:groups) }
    it { expect(student).to have_many(:results).dependent(:delete_all) }
  end

  describe '#full_name' do
    it 'give empty block when user have not any name' do
      student.attributes = {last_name: '', first_name: '', father_name: ''}
      expect(student.full_name).to eq ''
    end

    it 'give only last_name if first_name or father_name is not present' do
      teacher.attributes = {last_name: last_name, first_name: first_name, father_name: ''}
      expect(teacher.full_name).to eq last_name
      teacher.attributes = {last_name: last_name, first_name: '', father_name: father_name}
      expect(teacher.full_name).to eq last_name
    end

    it 'give full name in special format if all data present' do
      teacher.attributes = {last_name: last_name, first_name: first_name, father_name: father_name}
      expect(teacher.full_name).to eq "#{last_name} #{first_name[0]}. #{father_name[0]}."
    end
  end
end
