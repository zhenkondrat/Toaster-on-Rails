class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def edit; end

  def update
    attach_message current_user.update(profile_attributes), current_user.errors
  end

  def change_language
    service = ChangeLanguageService.new(current_user)
    attach_message service.change!(params[:name]), current_user.errors
    redirect_to :back
  end

  def reset_password
    attach_message current_user.send_reset_password_instructions
  end

  private

  def profile_attributes
    params.require(:user).permit(:login, :first_name, :last_name, :father_name)
  end
end
