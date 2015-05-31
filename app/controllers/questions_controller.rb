class QuestionsController < ApplicationController
  before_action :set_question, except: [:new, :create]
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
    @question = Question.new(toast_id: params[:toast])
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:notice] = 'Question successfully created'
    else
      flash[:error] = %q|Question can't be created|
    end
    redirect_to edit_toast_path(@question.toast)
  end

  def edit; end

  def update
    if @question.update(question_params)
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
    params.require(:question).permit(
      :toast_id, :text, :question_type, :is_right,
      plurals_attributes: [:id, :is_right, :text, :_destroy],
      associations_attributes: [:id, :left_text, :right_text, :_destroy]
    )
  end
end
