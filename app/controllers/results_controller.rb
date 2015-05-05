class ResultsController < ApplicationController
  load_and_authorize_resource
  include ResultsHelper

  def index
    @results = Result.includes([:user, { toast: :mark_system }]).order('results.created_at DESC').limit(5)
  end

  def show
    @users = User.joins(:groups, :results).where(groups: {id: params[:group][:id]}, results: {toast_id: params[:toast][:id]}).group('users.id').order(last_name: :asc)
  end

  def export
    @users = User.joins(:groups, :results).where(groups: {id: params[:group][:id]}, results: {toast_id: params[:toast][:id]}).group('users.id').order(last_name: :asc)

    file_name = "#{Group.find(params[:group][:id]).name}-result-#{Time.zone.now.strftime("%d/%m/%Y")}"
    respond_to do |format|
      format.xls { set_header('xls', "#{file_name}.xls") }
      format.doc { set_header('doc', "#{file_name}.doc") }
    end
  end

end
