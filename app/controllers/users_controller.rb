class UsersController < ApplicationController

  def index
    if !current_user
      redirect_to new_user_session_path
    else
      if current_user.admin
        if params.include? :theme || :subject || :group
          @tests = Test.all.where("'name' LIKE '"+params[:theme]+"%'")
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