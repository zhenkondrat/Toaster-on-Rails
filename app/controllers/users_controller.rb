class UsersController < ApplicationController

  def index
    if !current_user
      redirect_to new_user_session_path
    else
      if current_user.admin
        if params.include? :theme || :subject || :group
          subject = params[:subject][:subject_id]
          theme = params[:theme]
          group = params[:group]
          @tests = Test.find_tests subject, theme, group
          @select_find = subject.to_i unless subject.empty?
        end
        @test = Test.new
        render :admin
      else
        if session[:local]
          result = Result.new
          result.create_by_answers session[:answers], session[:questions], current_user.id
          session[:local] = nil
        end
        @results = current_user.results 5
        render :student
      end
    end
  end

private
  def search_test_params
    params.permit(:theme, :subject, :group)
  end
end