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
    InviteCode.generate!
    codes = InviteCode.local
    msg = {:status => "ok",
           :admin => codes[:admin],
           :user  => codes[:user]
          }
    render json: msg
  end

  private

    def admin_lock
      redirect_to root_path, error: 'You are not have permission!' unless current_user.admin
    end
end
