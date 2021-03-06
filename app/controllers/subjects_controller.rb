class SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subject, except: [:create, :index]
  load_and_authorize_resource

  def index
    @groups = Subject.search(current_user, params[:search_filter]).page(params[:page]).per(10)
    @subject = Subject.new
  end

  def create
    if current_user.subjects.create(subject_params)
      flash[:notice] = 'Subject is successfully created'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to subjects_path
  end

  def edit; end

  def update
    if @subject.update(subject_params)
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

  def share_to_teacher
    if @subject.teachers << User.find(params[:grant_id])
      flash[:notice] = 'Teachers subject access is granted'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_subject_path(@subject)
  end

  def deny_to_teacher
    if @subject.teachers.delete(params[:deny_id])
      flash[:notice] = 'Teachers subject access was successfully deleted'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_subject_path(@subject)
  end

  private

  def set_subject
    @subject = current_user.subjects.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name)
  end
end
