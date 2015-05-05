class QuestionsController < ApplicationController
  before_action :set_question, except: [:new, :create]
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
    @question = Question.new(toast_id: params[:toast])
    @plural_answer, @associative_answer = Answer2.new, Answer3.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      case @question.question_type
        when 2
          plural_answers_params.each_value{ |answer| @question.answer2s.create(text: answer['text'], is_right: answer['is_right'] || false) }
        when 3
          nil
      end
      flash[:notice] = 'Question successfully created'
    else
      flash[:error] = %q|Question can't be created|
    end
    redirect_to edit_toast_path(@question.toast)
  end

  def edit
    @answers = case @question.question_type
               when 2 then @question.answer2s
               when 3 then @question.answer3s
               end
  end

  def update
    if @question.update(question_params)
      case @question.question_type
        when 2
          plural_answers_params.each_pair do |key, answer|
            if key.index('new')
              @question.answer2s.create(text: answer['text'], is_right: answer['is_right'] || false)
            else
              Answer2.find(key.to_s.to_i).update(text: answer['text'], is_right: answer['is_right'] || false)
            end
          end
        when 3
          nil
      end
      flash[:notice] = 'Question successfully updated'
    else
      flash[:error] = %q|Question can't be updated|
    end
    redirect_to edit_toast_path(@question.toast)
  end

  def destroy
    toast = @question.toast
    if @question.destroy
      flash[:notice] = 'Question is successfully deleted'
    else
      flash[:error] = %q|Question can't be deleted|
    end
    redirect_to edit_toast_path(toast)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:toast_id, :text, :question_type, :is_right)
  end

  def plural_answers_params
    params.require(:plural_answers)
  end
end
