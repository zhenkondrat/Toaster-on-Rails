class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :question, only: :edit

  def new
    @question = Question.new(toast_id: params[:toast])
  end

  def create
    sanitize_params
    question = current_user.questions.create(question_params)
    attach_message question.persist?, question.errors
    redirect_to edit_toast_path(question.toast)
  end

  def edit; end

  def update
    attach_message question.update(question_params)
    redirect_to edit_toast_path(question.toast)
  end

  def destroy
    attach_message question.destroy, question.errors
    redirect_to edit_toast_path(question.toast)
  end

  private

  def question
    @question ||= Question.joins(:toasts)
                          .where(toasts: {owner_id: current_user.id})
                          .find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :toast_id, :text, :question_type, :is_right,
      plurals_attributes: [:id, :is_right, :text, :_destroy],
      associations_attributes: [:id, :left_text, :right_text, :_destroy]
    )
  end

  def sanitize_params
    case question_params[:question_type]
    when '2'
      params['question'].delete('plurals_attributes')
    when '3'
      params['question'].delete('associations_attributes')
    end
  end
end
