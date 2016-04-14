class MarkSystemsController < ApplicationController
  before_action :set_mark_system, except: [:index, :new, :create]
  load_and_authorize_resource

  def index
    @mark_systems = current_user.mark_systems.page(params[:page]).per(10)
  end

  def new
    @mark_system = MarkSystem.new
  end

  def create
    if current_user.mark_systems.create(mark_system_params)
      flash[:notice] = 'Mark system successfully created!'
    else
      flash[:error] = %q|Mark system can't be created|
    end
    redirect_to mark_systems_path
  end

  def edit; end

  def update
    if @mark_system.update(mark_system_params)
      flash[:notice] = 'Mark system successfully updated!'
    else
      flash[:error] = %q|Mark system can't be updated|
    end
    redirect_to mark_systems_path
  end

  def destroy
    if @mark_system.destroy
      flash[:notice] = 'Mark system successfully deleted!'
    else
      flash[:error] = %q|Mark system can't be deleted|
    end
    redirect_to mark_systems_path
  end

  private

  def set_mark_system
    @mark_system = current_user.mark_systems.find(params[:id])
  end

  def mark_system_params
    params.require(:mark_system)
          .permit(:name, marks_attributes: [:id, :presentation, :percent])
  end
end
