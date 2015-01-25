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
      before :each do
        5.times{ toast.questions.create(condition: Faker::Lorem.paragraph, question_type: 1) }
        5.times{ toast.questions.create(condition: Faker::Lorem.paragraph, question_type: 2) }
        5.times{ toast.questions.create(condition: Faker::Lorem.paragraph, question_type: 3) }
      end

      it 'should find all questions if I give not limit' do
        expect(toast.get_questions_list.size).to eq 15
      end

      it 'should find some count of questions if I give limit' do
        toast.questions_count = 5
        expect(toast.get_questions_list.size).to eq 5
      end
    end

  end
end
