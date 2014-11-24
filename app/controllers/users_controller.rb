class UsersController < ApplicationController
  before_action :authorization, except: :generate_invite_code

  def index
    redirect_to new_user_session_path
  end

  def student
    save_results if session[:pass_test]
    @results = current_user.results 5
  end

  def admin
    find_test if params.include? :theme || :subject || :group
    @test = Test.new
    @results = User.results 5
    @token = InviteCode.local
  end

  def generate_invite_code
    if current_user && current_user.admin
      InviteCode.generate!
      codes = InviteCode.local
      msg = { :status => "ok",
              :admin => codes[:admin],
              :user  => codes[:user]
      }
      render json: msg
    else
      flash[:error] = 'У вас немає прав для даної операції'
      redirect_to root_path
    end
  end
private

  def search_test_params
    params.permit(:theme, :subject, :group)
  end

  def find_test
    subject = params[:subject]
    theme = params[:theme]
    group = params[:group]
    @tests = Test.find_tests subject, theme, group
    @select_find = subject.to_i unless subject.empty?
  end

  def save_results
    result = Result.new
    result.create_by_answers(
      session[:answers],
      session[:questions],
      session[:test_id],
      current_user.id
    )
    session[:pass_test] = nil
  end

  def authorization
    case params[:action]
    when 'admin'
      redirect_to root_path unless current_user && current_user.admin
    when 'student'
      redirect_to root_path unless current_user && !current_user.admin
    else
      redirect_to admin_path if current_user && current_user.admin
      redirect_to student_path if current_user && !current_user.admin
    end
  end
end