require 'spec_helper'

describe Toast do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:group) {FactoryGirl.create(:group)}
  let(:admin) { FactoryGirl.create(:admin) }

  describe 'validates' do
    it { expect(toast).to validate_presence_of(:name) }
    it { expect(toast).to validate_presence_of(:mark_system) }
    it { expect(toast).to validate_presence_of(:subject) }
  end

  describe 'associations' do
    it { expect(toast).to have_and_belong_to_many(:groups) }
    it { expect(toast).to have_many(:results) }
    it { expect(toast).to have_many(:questions) }
    it { expect(toast).to belong_to(:mark_system) }
    it { expect(toast).to belong_to(:subject) }
  end

  describe 'methods' do

    describe '#find_toasts' do
      let(:teacher) { FactoryGirl.create(:teacher) }
      let(:another_subject) {FactoryGirl.create(:subject)}
      let(:another_toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: another_subject)}

      context 'toast finding by subject_id' do
        before { teacher.subjects << subject }

        it 'should find it if there is subjects teacher' do
          expect(Toast.search(teacher, subject_id: subject.id)).to include toast
        end

        it %q|shouldn't find it if there isn't subjects teacher| do
          expect(Toast.search(teacher, subject_id: another_subject.id)).not_to include toast
        end

        it %q|should find it if there is admin user| do
          expect(Toast.search(admin, subject_id: another_subject.id)).to contain_exactly(another_toast)
        end
      end

      it 'should find toast by group id' do
        group.toasts << toast
        expect(Toast.search(admin, {group_id: group.id})).to include toast
      end

      it 'should find toast by name' do
        expect(Toast.search(admin, {name: toast.name})).to include toast
      end

      it 'should find toast with few parameters' do
        group.toasts << toast
        expect(Toast.search(admin, {subject_id: subject.id, group_id: group.id, name: toast.name})).to include toast
      end
    end

    describe '#get_questions_list' do
      before :each do
        2.times{ toast.questions.create(text: Faker::Lorem.paragraph, question_type: 1) }
        2.times{ toast.questions.create(text: Faker::Lorem.paragraph, question_type: 2) }
        2.times{ toast.questions.create(text: Faker::Lorem.paragraph, question_type: 3) }
      end

      it 'should find all questions if I give not limit' do
        expect(toast.get_questions_list.size).to eq 6
      end

      it 'should find some count of questions if I give limit' do
        toast.questions_count = 3
        expect(toast.get_questions_list.size).to eq 3
      end
    end
  end
end
