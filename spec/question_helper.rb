module QuestionHelper
  def create_answers(question)
    case
    when question.plural? then create_plurals(question.plurals)
    when question.associative? then create_associations(question.associations)
    else fail 'Wrong question type'
    end
  end

  def user_right_answers(questions)
    user_answers = {}
    questions.each do |question|
      user_answers[question.id.to_s] =
        case question.question_type
        when 'logical'
          question.is_right.to_s
        when 'plural'
          answers = question.plurals.where(is_right: true)
          answers.map{ |a| [a.id, true] }.to_h
        when 'associative'
          answers = question.associations
          answers = answers.select{ |a| a.full_pair? }
          answers.map{ |a| [a.id, [a.left_text, a.right_text]] }.to_h
        end
    end
    user_answers
  end

  def user_wrong_answers(questions)
    user_answers = {}
    questions.each do |question|
      user_answers[question.id.to_s] =
        case question.question_type
        when 'logical'
          (!question.is_right).to_s
        when 'plural'
          answers = question.plurals.where(is_right: false)
          answers.map{ |a| [a.id, true] }.to_h
        when 'associative'
          answers = question.associations
          answers = answers.select{ |a| a.full_pair? }
          answers.map{ |a| [a.id, [a.left_text, '']] }.to_h
        end
    end
    user_answers
  end

  private

  def create_plurals(proxy)
    right_answers =
      (0..rand(2)).map do
        proxy.create(text: Faker::Lorem.word, is_right: true)
      end
    wrong_answers =
      (0..rand(2)).map do
        proxy.create(text: Faker::Lorem.word, is_right: false)
      end

    { right_answers: right_answers, wrong_answers: wrong_answers }
  end

  def create_associations(proxy)
    correct_pairs =
      (0..rand(2)).map do
        proxy.create(left_text: Faker::Lorem.word, right_text: Faker::Lorem.word)
      end
    one_sided =
      (0..rand(2)).map do
        proxy.create(left_text: Faker::Lorem.word)
      end

    { correct_pairs: correct_pairs, one_sided: one_sided }
  end
end
