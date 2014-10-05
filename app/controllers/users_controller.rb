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
        render :admin
      else
        render :student
      end
    end
  end

private
  def search_test_params
    params.permit(:theme, :subject, :group)
  end
end