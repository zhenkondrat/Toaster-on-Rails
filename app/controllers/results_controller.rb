class ResultsController < ApplicationController

  include ResultsHelper

  def index
    sql = <<-SQL
      SELECT results.id AS result_id, users.login AS user_login, toasts.name AS toast_name, results.mark*100 AS mark, results.created_at, mark_systems.id AS mark_system FROM results
      INNER JOIN toasts ON results.toast_id = toasts.id
      INNER JOIN users ON results.user_id = users.id
      INNER JOIN mark_systems ON toasts.mark_system_id = mark_systems.id
      ORDER BY results.created_at DESC
      LIMIT 5
    SQL
    @results = ActiveRecord::Base.connection.execute(sql).to_a
    for i in 0..@results.size-1 do
      sql = <<-SQL
        SELECT marks.presentation FROM marks WHERE marks.percent <= #{@results[i]['mark'].to_i} AND marks.mark_system_id = #{@results[i]['mark_system']} ORDER BY marks.percent DESC LIMIT 1
      SQL
      @results[i]['mark'] = ActiveRecord::Base.connection.execute(sql)[0]['presentation']
    end
  end

  def show
    @users = User.joins(:groups, :results).where(groups: {id: params[:group][:id]}, results: {toast_id: params[:toast][:id]}).group('users.id').order(last_name: :asc)
  end

  def export
    @users = User.joins(:groups, :results).where(groups: {id: params[:group_id]}, results: {toast_id: params[:toast_id]}).group('users.id').order(last_name: :asc)

    file_name = "#{Group.find(params[:group_id]).name}-result-#{Time.zone.now.strftime("%d/%m/%Y")}"
    respond_to do |format|
      format.xls { set_header('xls', "#{file_name}.xls") }
      format.doc { set_header('doc', "#{file_name}.doc") }
    end
  end

end
