class UsersController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!, except: [:index, :main]
  before_action :set_user, only: [:edit, :update]
  before_filter :admin_lock, except: :main

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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:login, :first_name, :last_name, :father_name)
  end
end
