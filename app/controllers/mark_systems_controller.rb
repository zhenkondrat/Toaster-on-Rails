class MarkSystemsController < ApplicationController
  before_action :authenticate_user!
  before_action :mark_system, only: :edit

  def index
    @mark_systems = current_user.mark_systems
                                .page(params[:page])
  end

  def new
    @mark_system = MarkSystem.new
  end

  def create
    @mark_system = current_user.mark_systems.create(mark_system_params)
    attach_message @mark_system.persist?, @mark_system.errors
    redirect_to mark_systems_path
  end

  def edit; end

  def update
    attach_message mark_system.update(mark_system_params), mark_system.errors
    redirect_to edit_mark_system_path(mark_system)
  end

  def destroy
    attach_message mark_system.destroy, mark_system.errors
    redirect_to mark_systems_path
  end

  private

  def mark_system
    @mark_system ||= current_user.mark_systems.find(params[:id])
  end

  def mark_system_params
    params.require(:mark_system)
          .permit(:name, marks_attributes: [:id, :presentation, :percent])
  end
end
