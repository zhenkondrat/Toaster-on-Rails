require 'spec_helper'

describe User do
  let(:user) {FactoryGirl.create(:user)}
  let(:last_name) {Faker::Name.last_name}
  let(:first_name) {Faker::Name.first_name}
  let(:father_name) {Faker::Name.first_name}

  describe 'validates' do
    it { expect(user).to validate_uniqueness_of(:login) }

    context 'student(user) must have last_name: ' do
      it 'admin can be without any names' do
        user.admin = true
        user.last_name = ''
        expect(user.valid?).to eq true
      end

      it %q|user can't be without last_name| do
        user.admin = false
        user.last_name = ''
        expect(user.valid?).to eq false
      end

      it %q|user is valid with last_name| do
        user.admin = false
        user.last_name = last_name
        expect(user.valid?).to eq true
      end
    end
  end

  describe 'associations' do
    it { expect(user).to have_many(:user_groups) }
    it { expect(user).to have_many(:groups) }
    it { expect(user).to have_many(:results) }
  end

  describe '#full_name' do
    it 'give empty block when user have not any name' do
      user.last_name, user.first_name, user.father_name = '', '', ''
      expect(user.full_name).to eq ''
    end

    it 'give only last_name if first_name or father_name is not present' do
      user.last_name, user.first_name, user.father_name = last_name, first_name, ''
      expect(user.full_name).to eq last_name
      user.last_name, user.first_name, user.father_name = last_name, '', father_name
      expect(user.full_name).to eq last_name
    end

    it 'give full name in special format if all data present' do
      user.last_name, user.first_name, user.father_name = last_name, first_name, father_name
      expect(user.full_name).to eq "#{last_name} #{first_name[0]}. #{father_name[0]}."
    end
  end

end
