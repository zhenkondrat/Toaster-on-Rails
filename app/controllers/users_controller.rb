class UsersController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!, except: :index
  before_filter :admin_lock, only: [:generate_invite_code]

  def index
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

  def generate_invite_code
    codes = InviteCode.generate!
    msg = {status: 'ok', admin: codes[:admin], user: codes[:user]}
    render json: msg
  end
end
