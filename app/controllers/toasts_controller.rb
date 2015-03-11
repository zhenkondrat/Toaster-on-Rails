class ToastsController < ApplicationController
  before_filter :admin_lock, except: :show
  before_action :set_toast, except: [:new, :create, :index]

  def index
    @toasts = Toast.search({name: params[:search_filter]}).page(params[:page]).per(10)
  end

  def new
    @toast = Toast.new
  end

  def create
    @toast = Toast.new(toast_params)
    if @toast.save
      redirect_to edit_toast_path(@toast), notice: 'Toast successfully created'
    else
      redirect_to new_toast_path(@toast), error: 'Something went wrong'
    end
  end

  def edit
    @questions = @toast.questions.page(params[:page]).per(10)
  end

  def update
    if @toast.update(toast_params)
      redirect_to edit_toast_path(@toast), notice: 'Toast successfully updated'
    else
      redirect_to new_toast_path(@toast), error: 'Something went wrong'
    end
  end

  def show
    redirect_to root_path, error: 'You are not able to pass toast' if current_user.admin?
    if !session[:toast_started]
      session[:toast_started] = true
      session[:questions] = @toast.get_questions_list
      session[:last_question] = 0
      session[:answers] = {}
      @question = Question.find(session[:questions].first)
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
    if @toast.toast_groups.create(group_id: params[:group][:id])
      flash[:notice] = 'Toast successfully shared'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_toast_path(@toast)
  end

  def deny_group
    if @toast.toast_groups.find_by_group_id(params[:group]).delete
      flash[:notice] = 'Group successfully deleted from shared list'
    else
      flash[:error] = 'Something went wrong'
    end
    render js: "window.location = '#{edit_toast_path(@toast)}'"
  end

  private

  def save_answer
    question_id = session[:questions][session[:last_question]]
    case Question.find(session[:questions][session[:last_question]]).question_type
      when 1
        session[:answers][question_id.to_i] = params[:is_right]
      when 2
        session[:answers][question_id.to_i] = {}
        params[:plural_answers].each_key{ |key| session[:answers][question_id][key] = true } if params[:plural_answers]
    end
  end

  def set_toast
    @toast = Toast.find(params[:id])
  end

  def toast_params
    params.require(:toast)
          .permit(:name,
                  :weight1,
                  :weight2,
                  :weight3,
                  :subject_id,
                  :questions_count,
                  :question_time,
                  :mark_system_id
          )
  end

end
