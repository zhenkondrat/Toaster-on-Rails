class SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :subject, only: :edit

  def index
    @subjects = Subject.search(current_user, params[:search_filter])
                       .page(params[:page])
    @subject = Subject.new
  end

  def create
    subject = current_user.subjects.create(subject_params)
    attach_message subject.persist? subject.errors
    redirect_to subjects_path
  end

  def edit; end

  def update
    attach_message subject.update(subject_params), subject.errors
    redirect_to subjects_path
  end

  def destroy
    attach_message subject.destroy, subject.errors
    redirect_to subjects_path
  end

  def change_teachers
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

  def subject
    @subject ||= current_user.subjects.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name)
  end
end
