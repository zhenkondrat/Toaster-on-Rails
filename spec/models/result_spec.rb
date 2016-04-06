require 'spec_helper'
require 'question_helper'

describe Result do
  include QuestionHelper

  let(:result) { create(:result) }

  describe 'validates' do
    it { expect(result).to validate_presence_of(:user) }
    it { expect(result).to validate_presence_of(:toast) }
    it { expect(result).to validate_presence_of(:hit) }
    it { expect(result).to validate_numericality_of(:hit).is_less_than_or_equal_to(1) }
  end

  describe 'associations' do
    it { expect(result).to belong_to(:user) }
    it { expect(result).to belong_to(:toast) }
  end

  describe 'methods' do
    describe '#presentation' do
      let(:marks){ result.toast.mark_system.marks.map(&:presentation) }

      it 'returns representation of mark' do
        expect(marks).to include(result.presentation)
      end
    end

    describe '#calc_and_save_by_answers' do
      let!(:questions) do
        (0..rand(2)+2).map do
          question = create("#{QuestionTypes::TYPE_LIST.sample}_question")
          create_answers(question) unless question.logical?
          question
        end
      end

      before { result.toast.update(mark_system: nil) }

      context 'when all answers are right' do
        before do
          result.update!(answers: user_right_answers(questions))
          result.calc_and_save_by_answers(questions)
        end

        it { expect(result.hit).to eq(1) }
        it { expect(result.right).to eq(questions.size) }
        it { expect(result.wrong).to eq(0) }
        it { expect(result.percent).to eq(100) }
      end

      context 'when answers are partly correct' do
        let(:right_count) { questions.size / 2 }
        let(:wrong_count) { questions.size - right_count }

        before do
          answers = {}
          answers.merge!(user_right_answers(questions[0..right_count-1]))
          answers.merge!(user_wrong_answers(questions[right_count..-1]))
          result.update!(answers: answers)
          result.calc_and_save_by_answers(questions)
        end

        it { expect(result.hit).to eq((right_count.to_f / questions.size).round(3)) }
        it { expect(result.right).to eq(right_count) }
        it { expect(result.wrong).to eq(wrong_count) }
        it { expect(result.percent).to eq((result.hit * 100).round) }
      end
    end
  end
end
