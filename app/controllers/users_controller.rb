class UsersController < ApplicationController

  def index
    if !current_user
      redirect_to new_user_session_path
    else
      if current_user.admin
        render :admin
      else
        render :student
      end
    end
  end


end