require 'spec_helper'

shared_examples_for 'a stored integer field' do |field_name|
  context "#{field_name} is nil" do
    before { toast.send("#{field_name}=", nil) }

    it { expect(toast).to be_valid }
  end

  context "#{field_name} isn't integer or nil" do
    before { toast.send("#{field_name}=", Faker::Lorem.word) }

    it { expect(toast).to be_invalid }
  end
end

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

    describe '#answer_time_limits' do
      it_should_behave_like 'a stored integer field', :answer_time_limit

      context 'answer_time_limit is less then 10' do
        before { toast.answer_time_limit = rand(10) }

        it { expect(toast).to be_invalid }
      end

      context 'answer_time_limit is greater or eq then 10' do
        before { toast.answer_time_limit = 10 + rand(5) }

        it { expect(toast).to be_valid }
      end
    end

    describe '#questions_count_limits' do
      it_should_behave_like 'a stored integer field', :questions_count

      context 'questions_count is less then 1' do
        before { toast.questions_count = 0 }

        it { expect(toast).to be_invalid }
      end

      context 'questions_count is greater then 0' do
        before do
          count = rand(1..3)
          toast.questions_count = count
          count.times{ toast.questions << create(:question) }
        end

        it { expect(toast).to be_valid }
      end
    end
  end

  describe 'associations' do
    it { expect(toast).to belong_to(:mark_system) }
    it { expect(toast).to belong_to(:subject) }
    it { expect(toast).to have_many(:results) }
    it { expect(toast).to have_and_belong_to_many(:groups) }
    it { expect(toast).to have_and_belong_to_many(:questions) }
  end

  describe 'callbacks' do
    describe '#set_default_weights' do
      before do
        toast.weights = { 'logical' => 4 }
        toast.valid?
      end

      it { expect(toast.weights['logical']).to eq 4 }
      it { expect(toast.weights['plural']).to eq 1 }
      it { expect(toast.weights['associative']).to eq 1 }
    end
  end

  describe '.search' do
    let(:teacher) { FactoryGirl.create(:teacher) }
    let(:another_subject) {FactoryGirl.create(:subject)}
    let(:another_toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: another_subject)}

    context 'by subject_id' do
      before { teacher.subjects << subject }

      context 'finds toast' do
        it 'if user is subjects teacher' do
          expect(Toast.search(teacher, subject_id: subject.id)).to include toast
        end

        it 'if user is admin' do
          expect(Toast.search(admin, subject_id: another_subject.id)).to contain_exactly(another_toast)
        end
      end

      context %q|doesn't find toast| do
        it %q|if user isn't subjects teacher| do
          expect(Toast.search(teacher, subject_id: another_subject.id)).not_to include toast
        end
      end
    end

    context 'by group_id' do
      it 'finds toast' do
        group.toasts << toast
        expect(Toast.search(admin, { group_id: group.id })).to include toast
      end

      it %q|doesn't find toast| do
        group.toasts << another_toast
        expect(Toast.search(admin, { group_id: group.id })).not_to include toast
      end
    end

    context 'by name' do
      it 'finds toast by name' do
        expect(Toast.search(admin, { name: toast.name })).to include toast
      end

      it %q|doesn't find toast| do
        expect(Toast.search(admin, { name: another_toast.name })).to include toast
      end
    end

    context 'by few parameters' do
      before { group.toasts << toast }

      it 'finds toast' do
        criteria = { subject_id: subject.id, group_id: group.id, name: toast.name }
        expect(Toast.search(admin, criteria)).to include toast
      end

      it %q|doesn't find toast| do
        criteria = { subject_id: subject.id, group_id: group.id, name: another_toast.name }
        expect(Toast.search(admin, criteria)).to include toast
      end
    end
  end

  describe '#get_questions_list' do
    before :each do
      2.times{ toast.questions.create(text: Faker::Lorem.paragraph, question_type: 1) }
      2.times{ toast.questions.create(text: Faker::Lorem.paragraph, question_type: 2) }
      2.times{ toast.questions.create(text: Faker::Lorem.paragraph, question_type: 3) }
    end

    context %q|when I don't set limit| do
      before { toast.questions_count = 0 }

      it %q|finds all questions| do
        expect(toast.get_questions_list.size).to eq 6
      end
    end

    context 'when I set limit' do
      before { toast.questions_count = 3 }

      it 'finds limited count of questions' do
        expect(toast.get_questions_list.size).to eq 3
      end
    end
  end

  describe '#foreign_groups' do
    let!(:group) { create(:group) }
    let!(:foreign_group) { create(:group) }

    before { toast.groups << group }

    it { expect(toast.foreign_groups).not_to include(group) }
    it { expect(toast.foreign_groups).to include(foreign_group) }
  end
end
