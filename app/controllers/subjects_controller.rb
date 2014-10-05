class SubjectsController < ApplicationController
  def new
    @subject = Subject.new
  end

  def create
    Subject.create! subject_params
    flash[:notice] = 'Предмет успішно створено'
    redirect_to root_path
  end

  def delete
    Subject.find(params[:id]).destroy!
    flash[:notice] = 'Предмет успішно видалено'
    redirect_to root_path
  end

  private

  def subject_params
    params.require(:subject).permit(:subject_name)
  end
end
