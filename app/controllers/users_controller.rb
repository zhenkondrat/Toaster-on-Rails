class UsersController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!, except: [:index, :main]
  before_filter :admin_lock, only: [:generate_invite_code]

  def main
    respond_with do |format|
      format.html do
        if user_signed_in?
          render current_user.admin ? 'users/admin/home' : 'users/user/home'
        else
          redirect_to new_user_session_path
        end
      end
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  # def search
  #   search_filter = params[:search_filter]
  #   byebug
  #   render json: User.all.to_json
  # end

  def generate_invite_code
    codes = InviteCode.generate!
    msg = {status: 'ok', admin: codes[:admin], user: codes[:user]}
    render json: msg
  end

  def join_group
    @group = Group.find(params[:group][:id])
    params[:reg_users].each{ |user_id| @group.user_groups.create(user_id: user_id) }
    redirect_to users_path, notice: 'Users are successfully joined to group'
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
end
