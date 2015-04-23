class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit({ roles: [] }, :login, :password, :remember_me) }
  end

  def admin_lock
    redirect_to root_path, error: 'You are not have permission!' unless current_user.try(:admin)
  end
end
