require 'spec_helper'
require 'question_helper'

describe Result do
  let(:mark_system) {FactoryGirl.create(:mark_system)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:toast) {FactoryGirl.create(:toast, mark_system: mark_system, subject: subject)}
  let(:user) {FactoryGirl.create(:user)}
  let(:result) {FactoryGirl.create(:result, user: user, toast: toast)}

  describe 'validates' do
    it { expect(result).to validate_presence_of(:user) }
    it { expect(result).to validate_presence_of(:toast) }
    it { expect(result).to validate_presence_of(:mark) }
    it { expect(result).to validate_presence_of(:created_at) }
    it { expect(result).to validate_numericality_of(:mark).is_less_than_or_equal_to(1) }
  end

  describe 'associations' do
    it { expect(result).to belong_to(:user) }
    it { expect(result).to belong_to(:toast) }
  end

  describe 'methods' do
    describe '#show_mark' do
      it %q|should give decimal number if toast haven't mark system| do
        result.toast.mark_system = nil
        expect(result.show_mark.to_f).to be <= 1
      end

      it %q|should give me presentation of mark if toast have mark system| do
        marks = []
        mark = Mark.create(presentation: Faker::Lorem.word, percent: 0, mark_system: mark_system)
        marks.push mark.presentation
        puts 'Marks list:'
        puts "#{mark.presentation} - #{mark.percent}"
        4.times do
          mark = Mark.create(presentation: Faker::Lorem.word, percent: Random.rand(100), mark_system: mark_system)
          marks.push mark.presentation
          puts "#{mark.presentation} - #{mark.percent}%"
        end
        result.toast.update(mark_system: mark_system)
        puts "You have: #{result.mark*100.round}%. Your mark: #{result.show_mark}"
        expect(marks).to include result.show_mark
      end
    end

    describe '#create_by_answers' do
      it 'should get the greatest mark if I know all right answers' do
        user_answers, questions = {}, []
        toast.update(mark_system: nil)
        Random.rand(1..20).times do
          question = Question.create(toast: toast,
                                     text: Faker::Lorem.paragraph,
                                     question_type: Random.rand(1..3),
                                     is_right: (Random.rand(1).zero? ? false : true)
                     )
          question_answers = create_answers(question) unless question.question_type == 1
          case question.question_type
          when 1
            user_answers[question.id] = question.is_right
          when 2
            local_answer = {}
            question_answers[:right_answers].each{ |answer| local_answer[answer.id] = answer.is_right }
            user_answers[question.id] = local_answer
          when 3
            local_answer = {}
            question_answers[:correct_pairs].each{ |answer| local_answer[answer.id] = [answer.left_text, answer.right_text] }
            user_answers[question.id] = local_answer
          end
          questions.push question
        end
        expect(result.create_by_answers(questions, user_answers)).to eq '1.0'
      end
    end
  end
end
