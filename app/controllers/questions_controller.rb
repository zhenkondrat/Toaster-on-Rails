class QuestionsController < ApplicationController

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
        answer = Answer1.new
        answer.question_id = question.id
        answer.is_right = params[:answer1]
        answer.save!
      when "2"
        i = 0
        while params.include? ('answer_'+i.to_s)
          answer = Answer2.new
          answer.question_id = question.id
          answer.answer = params['answer_'+i.to_s]
          answer.is_right = params[:answer_check].include? i.to_s
          answer.save!
          i+=1
        end
      when "3"
        i = 0
        while params.include? ('answer_left_'+i.to_s)
          answer = Answer3.new
          answer.question_id = question.id
          answer.field = params['answer_left_'+i.to_s]
          answer.side = 0
          answer.save!
          i+=1
        end
        i = 0
        while params.include? ('answer_right_'+i.to_s)
          answer = Answer3.new
          answer.question_id = question.id
          answer.field = params['answer_right_'+i.to_s]
          answer.side = 1
          answer.save!
          i+=1
        end
      end
    end
    redirect_to new_question_path(:question_test_id => test_id)
  end

  def edit

  end

  private

  def question_params
    params.require(:question).permit(:question_test_id, :condition, :question_type)
  end
end
