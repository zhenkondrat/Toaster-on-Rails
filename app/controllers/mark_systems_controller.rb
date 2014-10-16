class MarkSystemsController < ApplicationController

  def save_marks mark_system_id
    marks = mark_systems_params[:marks]
    i = 1
    while marks.include? 'percent_'+i.to_s
      mark = Mark.new
      mark.mark_system_id = mark_system_id
      mark.presentation = marks['presentation_'+i.to_s]
      mark.percent = marks['percent_'+i.to_s]
      mark.save!
      i+=1
    end
  end

  def new
    @mark_system = MarkSystem.new
    @marks = []
  end

  def create
    mark_system = MarkSystem.create! name: mark_systems_params[:name]
    save_marks mark_system.id

    flash[:notice] = 'Система оцінювання створена'
    redirect_to edit_mark_system_path(mark_system.id)
  end

  def edit
    @mark_system = MarkSystem.find(params[:id])
    @marks = Mark.where(mark_system: params[:id])
  end

  def update
    @mark_system = MarkSystem.find(params[:id])
    if @mark_system.name != mark_systems_params[:name]
      @mark_system.name = mark_systems_params[:name]
      @mark_system.save!
    end

    save_marks @mark_system.id

    flash[:notice] = 'Система оцінювання оновлена'
    redirect_to edit_mark_system_path(params[:id])
  end


  def destroy
    MarkSystem.find(params[:id]).destroy
    flash[:notice] = 'Система оцінювання видалена'
    redirect_to root_path
  end

  private

  def mark_systems_params
    params.require(:mark_system)
  end
end