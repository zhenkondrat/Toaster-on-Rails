class SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_filter :admin_lock
  before_action :set_subject, except: [:create, :index]

  def index
    @subjects = Subject.page(params[:page]).per(10)
    @subject = Subject.new
  end

  def create
    if Subject.create subject_params
      flash[:notice] = 'Subject is successfully created'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to subjects_path
  end

  def edit
  end

  def update
    if @subject.update subject_params
      flash[:notice] = 'Subject is successfully updated'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to subjects_path
  end

  def delete
    if @subject.destroy
      flash[:notice] = 'Subject is successfully deleted'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to subjects_path
  end

  private

    def set_subject
      @subject = Subject.find(params[:id])
    end

    def subject_params
      params.require(:subject).permit(:name)
    end
end
