class QuestionsController < ApplicationController

  def create_answer1 question
    answer = Answer1.new
    answer.question_id = question.id
    answer.is_right = params[:answer1]
    answer.save!
  end

  def create_answer2 question
    i = 0
    while params.include? ('answer_'+i.to_s)
      answer = Answer2.new
      answer.question_id = question.id
      answer.answer = params['answer_'+i.to_s]
      answer.is_right = params[:answer_check].include? i.to_s
      answer.save!
      i+=1
    end
  end

  def create_answer3 question
    compare = []
    i = 0
    while params.include? ('answer_left_'+i.to_s)
      answer = Answer3.new
      answer.question_id = question.id
      answer.field = params['answer_left_'+i.to_s]
      answer.side = 0
      answer.save!
      compare.push answer.id
      i+=1
    end
    compare.reverse!
    i = 0
    while params.include? ('answer_right_'+i.to_s)
      answer = Answer3.new
      answer.question_id = question.id
      answer.field = params['answer_right_'+i.to_s]
      answer.side = 1
      answer.compare = compare.pop
      answer.save!
      i+=1
    end
  end

  def new
    @question = Question.new
    @test = Test.find(params[:question_test_id])
  end

  def create
    type = question_params[:question_type]
    test_id = question_params[:question_test_id]

    if type.nil?
      flash[:error] = "Ви не вказали тип питання"
    else
      question = Question.new
      question.test_id = question_params[:question_test_id]
      question.condition = question_params[:condition]
      question.question_type = question_params[:question_type]
      question.save!
      case type
      when "1"
        create_answer1 question
      when "2"
        create_answer2 question
      else
        create_answer3 question
      end
    end
    redirect_to new_question_path(:question_test_id => test_id)
  end

  def edit
    @question = Question.find(params[:id])
    case @question.question_type
    when 1
      @answer = Answer1.where(:question_id => @question.id).first
    when 2
      @answers = Answer2.where(:question_id => @question.id)
    else
      answers = Answer3.where(:question_id => @question.id)
      @answers1 = answers.where(:side => 0)
      @answers2 = answers.where(:side => 1)
    end
  end

  def update
    question = Question.find(params[:id])
    question.condition = question_params[:condition]
    question.remove_answers
    case question.question_type
    when 1
      create_answer1 question
    when 2
      create_answer2 question
    else
      create_answer3 question
    end
    flash[:error] = 'Питання успішно оновлено'
    redirect_to edit_test_path(question.test_id)
  end

  def destroy
    question = Question.find(params[:id])
    test_id = question.test_id
    question.destroy

    flash[:notice] = 'Питання успішно видалено'
    redirect_to edit_test_path(test_id)
  end

  private

  def question_params
    params.require(:question).permit(:question_test_id, :condition, :question_type)
  end
end
