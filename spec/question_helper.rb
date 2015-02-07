def create_answers question
  case question.question_type
    when 2
      right_answers, wrong_answers = [], []
      Random.rand(5).times { right_answers.push question.answer2s.create(text: Faker::Lorem.word, is_right: true) }
      Random.rand(5).times { wrong_answers.push question.answer2s.create(text: Faker::Lorem.word, is_right: false) }
      return { right_answers: right_answers, wrong_answers: wrong_answers }
    when 3
      correct_pairs, single_records = [], []
      Random.rand(5).times { correct_pairs.push question.answer3s.create(left_text: Faker::Lorem.word, right_text: Faker::Lorem.word) }
      Random.rand(5).times { single_records.push question.answer3s.create(left_text: Faker::Lorem.word, right_text: nil) }
      return { correct_pairs: correct_pairs, single_records: single_records }
    else
      fail 'Wrong question type'
  end
end
