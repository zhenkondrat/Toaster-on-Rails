class ToastsController < ApplicationController
  before_action :set_toast, except: [:new, :create, :index]
  load_and_authorize_resource

  def index
    @toasts = Toast.search(current_user, name: params[:search_filter])
                   .page(params[:page])
  end

  def new
    @toast = Toast.new
  end

  def create
    @toast = if toast_params[:parser_file]
               ToastParser.parse(toast_params)
             else
               Toast.create(toast_params)
             end
    if @toast
      redirect_to edit_toast_path(@toast), notice: 'Toast successfully created'
    else
      redirect_to new_toast_path(@toast), error: 'Something went wrong'
    end
  end

  def edit
    @questions = @toast.questions.order(:id).page(params[:page]).per(10)
  end

  def update
    if @toast.update(toast_params)
      redirect_to edit_toast_path(@toast), notice: 'Toast successfully updated'
    else
      redirect_to new_toast_path(@toast), error: 'Something went wrong'
    end
  end

  def show
    if !session[:toast_started]
      init_passing
    else
      current_question = session[:last_question] + 1
      save_answer
      if current_question == session[:questions].size
        redirect_to root_path
      else
        @question = Question.find(session[:questions][current_question]) if current_question
        session[:last_question] = current_question
      end
    end
  end

  def destroy
    if @toast.delete
      flash[:notice] = 'Toast successfully deleted'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to toasts_path
  end

  def share_to_group
    if @toast.groups << Group.find(params[:group][:id])
      flash[:notice] = 'Toast successfully shared'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_toast_path(@toast)
  end

  def deny_to_group
    if @toast.groups.delete(params[:deny_id])
      flash[:notice] = 'Group successfully deleted from shared list'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_toast_path(@toast)
  end

  def add_child
    if @toast.children << Toast.find(params[:child][:id])
      flash[:notice] = 'Child toast successfully added'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_toast_path(@toast)
  end

  def remove_child
    if @toast.children.delete(params[:deny_id])
      flash[:notice] = 'Toast has been removed from children list'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_toast_path(@toast)
  end

  private

  def init_passing
    session[:toast_started] = true
    session[:toast_id] = @toast.id
    session[:questions] = @toast.get_questions_list
    session[:last_question] = 0
    session[:answers] = {}
    @question = Question.find(session[:questions].first)
  end

  def save_answer
    question_id = session[:questions][session[:last_question]].to_i
    question_type = Question.find(question_id).question_type
    session[:answers][question_id] =
      case question_type
      when 1
        params[:is_right]
      when 2
        params[:plural_answers].present? ? params[:plural_answers].keys.map{ |key| [key, true] }.to_h : nil
      when 3
        params[:associations_right].present? ? [:right, :left].map{|s| [s, params["associations_#{s}"].split(',')]}.to_h : nil
      end
  end

  def set_toast
    @toast = Toast.find(params[:id])
  end

  def toast_params
    params.require(:toast).permit(:name, :weight1, :weight2, :weight3, :subject_id, :questions_count, :question_time,
                                  :learning_flag, :mark_system_id, :parser_file)
  end
end
