class UsersController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_user!
  before_filter :admin_lock, only: [:generate_invite_code]

  def index
    respond_with do |format|
      format.html {render 'users/admin/home' if current_user.admin}
      format.html {render 'users/user/home' unless current_user.admin}
    end
  end

  def generate_invite_code
    codes = InviteCode.generate!
    msg = {status: 'ok', admin: codes[:admin], user: codes[:user]}
    render json: msg
  end
end
