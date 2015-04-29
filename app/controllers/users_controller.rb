class UsersController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!, except: [:index, :main]
  before_action :set_user, only: [:edit, :update, :destroy]
  before_filter :admin_lock, except: [:main, :results]

  def main
    respond_with do |format|
      format.html do
        if user_signed_in?
          save_result if session[:toast_started]
          prepare_results unless (current_user.teacher? || current_user.admin?)
          render (current_user.teacher? || current_user.admin?)  ? 'users/teacher/home' : 'users/user/home'
        else
          redirect_to new_user_session_path
        end
      end
    end
  end

  def index
    @users = User.search(params[:search_filter]).page(params[:page]).per(30)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'User is successfully updated'
    else
      flash[:error] = %q|User can't be updated|
    end
    redirect_to users_path
  end

  def destroy
    if @user.delete
      flash[:notice] = 'User is successfully destroyed'
    else
      flash[:error] = %q|User can't be destroyed|
    end
    redirect_to users_path
  end

  def results
    # sql = <<-SQL
    #   SELECT subjects.name AS subject_name, toasts.name AS toast_name, marks.presentation AS f_mark, results.created_at FROM results
    #   INNER JOIN users ON results.user_id = users.id
    #   INNER JOIN toasts ON results.toast_id = toasts.id
    #   INNER JOIN subjects ON toasts.subject_id = subjects.id
    #   INNER JOIN mark_systems ON toasts.mark_system_id = mark_systems.id
    #   INNER JOIN marks ON marks.mark_system_id = mark_systems.id
    #   WHERE marks.percent <= results.mark*100
    #   AND results.user_id = #{current_user.id}
    #   ORDER BY results.created_at DESC
    # SQL
    # @results = ActiveRecord::Base.connection.execute(sql)
    @results = current_user.results.order(created_at: :desc).page(params[:page]).per(5)
    render 'users/user/results'
  end

  def generate_invite_code
    codes = InviteCode.generate!
    msg = {status: 'ok', admin: codes[:admin], user: codes[:user]}
    render json: msg
  end

  def join_group
    @group = Group.find(params[:group])
    params[:users].each{ |user_id| @group.user_groups.create(user_id: user_id) }
    flash[:notice] = 'Users are successfully joined to group'
    render js: "window.location = '#{users_path}'"
  end

  def leave_group
    @group = Group.find(params[:group])
    if @group.out(params[:id])
      flash[:notice] = 'User is successfully expelled from group'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_group_path(@group)
  end

  def change_locale
    I18n.locale = (I18n.locale == :en ? :uk : :en)
    current_user.update(config: {locale: I18n.locale})
    redirect_to root_path, notice: 'Locale successfully changed'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:login, :first_name, :last_name, :father_name)
  end

  def save_result
    result = current_user.results.new
    mark = result.create_by_answers(Question.where(id: session[:questions]), session[:answers])
    flash[:success] = "Your mark is: #{mark}"
    session[:toast_started] = false
  end

  def prepare_results
    sql = <<-SQL
      SELECT results.id AS result_id, subjects.name AS subject_name, toasts.name AS toast_name, results.mark*100 AS mark, results.created_at, mark_systems.id AS mark_system FROM results
      INNER JOIN toasts ON results.toast_id = toasts.id
      INNER JOIN subjects ON toasts.subject_id = subjects.id
      INNER JOIN mark_systems ON toasts.mark_system_id = mark_systems.id
      WHERE results.user_id = #{current_user.id}
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
end

# SELECT results.id, results.mark AS rm, (SELECT marks.presentation WHERE marks.percent <= rm*100 ORDER BY marks.percent DESC LIMIT 1) AS f_mark FROM results
# SELECT marks.presentation WHERE marks.percent <= results.mark ORDER BY marks.percent ASC LIMIT 1

# SELECT subjects.name AS subject_name, toasts.name AS toast_name, results.mark*100 AS f_mark, results.created_at FROM results
# INNER JOIN toasts ON results.toast_id = toasts.id
# INNER JOIN subjects ON toasts.subject_id = subjects.id
# WHERE results.user_id = #{current_user.id}
# ORDER BY results.created_at DESC

# SELECT subjects.name AS subject_name, toasts.name AS toast_name, marks.presentation AS f_mark, results.created_at FROM results
# INNER JOIN users ON results.user_id = users.id
# INNER JOIN toasts ON results.toast_id = toasts.id
# INNER JOIN subjects ON toasts.subject_id = subjects.id
# INNER JOIN mark_systems ON toasts.mark_system_id = mark_systems.id
# INNER JOIN marks ON marks.mark_system_id = mark_systems.id
# WHERE marks.percent <= results.mark*100
# AND results.user_id = #{current_user.id} ORDER BY results.created_at DESC
# LIMIT 5

# SELECT subjects.name AS subject_name, toasts.name AS toast_name,
# (SELECT marks.presentation WHERE marks.percent <= results.mark ORDER BY marks.percent ASC LIMIT 1) AS f_mark,
# results.created_at FROM results
# INNER JOIN users ON results.user_id = users.id
# INNER JOIN toasts ON results.toast_id = toasts.id
# INNER JOIN subjects ON toasts.subject_id = subjects.id
# INNER JOIN mark_systems ON toasts.mark_system_id = mark_systems.id
# INNER JOIN marks ON marks.mark_system_id = mark_systems.id
# ORDER BY results.created_at DESC
