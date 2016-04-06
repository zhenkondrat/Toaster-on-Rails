require 'spec_helper'
require 'question_types'

describe Question do
  let(:question) { create(:question) }
  let(:plural) { create(:plural_question) }
  let(:associative) { create(:associative_question) }

  describe 'validates' do
    it { expect(question).to validate_presence_of(:text) }
    it { expect(question).to validate_inclusion_of(:question_type).in_array(QuestionTypes::TYPE_LIST) }

    describe 'answers presence' do
      context 'in plural question' do
        context 'when plurals are present' do
          it { expect(plural).to be_valid }
        end

        context %q|when answers aren't present| do
          before { plural.assign_attributes(plurals: []) }

          it { expect(plural).to be_invalid }
        end
      end

      context 'in associative question' do
        context 'when all associations are present' do
          it { expect(associative).to be_valid }
        end

        context 'when only one association present' do
          before do
            answers = associative.associations
            answers.limit(answers.size-1).destroy_all
            answers.reload
          end

          it { expect(associative).to be_invalid }
        end

        context 'when there are no full pair association' do
          before do
            criteria = 'left_text IS NOT NULL AND right_text IS NOT NULL'
            associative.associations.where(criteria).delete_all
            associative.associations.reload
          end

          it { expect(associative).to be_invalid }
        end
      end
    end
  end

  describe 'associations' do
    it { expect(question).to have_and_belong_to_many(:toasts) }
    it { expect(question).to have_many(:plurals).dependent(:delete_all) }
    it { expect(question).to have_many(:associations).dependent(:delete_all) }
    it { expect(question).to accept_nested_attributes_for(:plurals) }
    it { expect(question).to accept_nested_attributes_for(:associations) }
  end

  describe 'methods' do
    describe '#shuffle_answers' do
      context 'plural type' do
        it { expect(plural.shuffle_answers).not_to eq plural.plurals }
        it { expect(plural.shuffle_answers.sort).to eq plural.plurals.sort }
      end

      context 'associative type' do
        let(:left_side) { associative.associations.map(&:left_text).compact }
        let(:right_side) { associative.associations.map(&:right_text).compact }

        it { expect(associative.shuffle_answers).not_to eq [left_side, right_side] }
        it { expect(associative.shuffle_answers.first.sort).to eq left_side.sort }
        it { expect(associative.shuffle_answers.last.sort).to eq right_side.sort }
      end

      context 'wrong type' do
        it { expect{ question.shuffle_answers }.to raise_error('wrong question type to shuffle answers') }
      end
    end

    describe 'question types' do
      describe '#logical?' do
        it { expect(question.logical?).to eq true }
        it { expect(plural.logical?).to eq false }
        it { expect(associative.logical?).to eq false }
      end

      describe '#plural?' do
        it { expect(question.plural?).to eq false }
        it { expect(plural.plural?).to eq true }
        it { expect(associative.plural?).to eq false }
      end

      describe '#associative?' do
        it { expect(question.associative?).to eq false }
        it { expect(plural.associative?).to eq false }
        it { expect(associative.associative?).to eq true }
      end
    end
  end
end
