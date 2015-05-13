class MarkSystemsController < ApplicationController
  before_action :set_mark_system, except: [:index, :new, :create]
  load_and_authorize_resource

  def index
    @mark_systems = MarkSystem.page(params[:page]).per(10)
  end

  def new
    @mark_system = MarkSystem.new
  end

  def create
    mark_system = MarkSystem.new(name: mark_system_params[:name])
    if mark_system.save && marks_params[:new].map{ |_, mark_params| mark_system.marks.create(mark_params).valid? }.reduce(:'&&')
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
      marks_params[:old].each_key{ |id| Mark.find(id).update(marks_params[:old][id]) }
      marks_params[:new].each_value{ |mark_params| @mark_system.marks.create(mark_params) }
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
    {name: params.require(:mark_system)[:name]}
  end

  def marks_params
    marks = {new: {}, old: {}}
    params.require(:mark_system)[:marks].each_pair do |key, value|
      marks[key.index('new') ? :new : :old][key] = { presentation: value['presentation'], percent: value['percent'] }
    end
    marks
  end
end
