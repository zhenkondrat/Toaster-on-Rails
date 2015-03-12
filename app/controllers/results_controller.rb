class ResultsController < ApplicationController
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
    group_id = params[:group][:id]
    @users = User.joins(:groups).where(groups: {id: group_id}).order(last_name: :asc)
  end
end
