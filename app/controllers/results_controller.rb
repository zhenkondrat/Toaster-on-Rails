class ResultsController < ApplicationController
  load_and_authorize_resource
  include ResultsHelper

  def index
    @results = Result.includes([:user, { toast: :mark_system }]).order('results.created_at DESC').limit(5)
  end

  def show
    results = Result.arel_table
    @users = User.joins(:groups).joins('LEFT JOIN results ON results.user_id = users.id')
                 .where(groups: {id: params[:group][:id]})
                 .where(results[:toast_id].eq(params[:toast][:id]).or(results[:toast_id].eq(nil)))
                 .group('users.id').order(last_name: :asc)
  end

  def export
    results = Result.arel_table
    @users =
      User.joins(:groups).joins('LEFT JOIN results ON results.user_id = users.id')
          .where(groups: {id: params[:group][:id]})
          .where(results[:toast_id].eq(params[:toast][:id]).or(results[:toast_id].eq(nil)))
          .group('users.id').order(last_name: :asc)

    @group = Group.find(params[:group][:id])
    @toast = Toast.find(params[:toast][:id])
    file_name = "#{Group.find(params[:group][:id]).name}-result-#{Time.zone.now.strftime('%d/%m/%Y')}"
    respond_to do |format|
      format.xls { set_header('xls', "#{file_name}.xls") }
      format.doc { set_header('doc', "#{file_name}.doc") }
    end
  end
end
