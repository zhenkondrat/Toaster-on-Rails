class ToastsController < ApplicationController
  before_filter :admin_lock, except: :show
  before_action :set_toast, except: [:new, :create, :index]

  def index
    @toasts = Toast.paginate(page: params[:page])
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
    @questions = @toast.questions.paginate(page: params[:page])
  end

  def update
    if @toast.update(toast_params)
      redirect_to edit_toast_path(@toast), notice: 'Toast successfully updated'
    else
      redirect_to new_toast_path(@toast), error: 'Something went wrong'
    end
  end

  def show
  end

  private

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
