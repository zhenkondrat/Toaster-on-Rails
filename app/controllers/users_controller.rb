class UsersController < ApplicationController

  def index
    if !current_user
      redirect_to new_user_session_path
    else
      if current_user.admin
        if params.include? :theme || :subject || :group
          query = if params[:subject][:subject_id].empty?
                    "'name' LIKE '"+params[:theme]+"%'"
                  else
                    "'name' LIKE '"+params[:theme]+"%' AND subject_id = "+params[:subject][:subject_id]
                  end
          @tests = Test.all.where(query)
          @select_find = params[:subject][:subject_id].to_i
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