class MarkSystemsController < ApplicationController
  before_filter :admin_lock
  before_action :set_mark_system, except: [:index, :new, :create]

  def index
    @mark_systems = MarkSystem.page(params[:page]).per(10)
  end

  def new
    @mark_system = MarkSystem.new
  end

  def create
    mark_system = MarkSystem.create(name: mark_system_params[:name])
    if mark_system
      mark_system_params[:marks][:new].each_value{ |mark_params| mark_system.marks.create(mark_params) }
      flash[:notice] = 'Mark system successfully created!'
    else
      flash[:error] = %q|Mark system can't be created|
    end
    redirect_to mark_systems_path
  end

  def edit
  end

  def update
    @mark_system.update(name: mark_system_params[:name])
    if @mark_system.errors.empty?
      mark_system_params[:marks][:old].each_key{ |id| Mark.find(id).update_all(mark_system_params[:marks][:old][id]) }
      mark_system_params[:marks][:new].each_value{ |mark_params| @mark_system.marks.create(mark_params) }
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
    @mark_system = MarkSystem.find(params[:id])
  end

  def mark_system_params
    mark_system = { name: params.require(:mark_system)[:name], marks: {new: {}, old: {}} }
    params.require(:mark_system)[:marks].each_key do |key|
      mark_system[:marks][key.index('new') ? :new : :old][key] =
        {
          presentation: params[:mark_system][:marks][key.to_sym]['presentation'],
          percent: params[:mark_system][:marks][key.to_sym]['percent']
        }
    end
    mark_system
  end
end
