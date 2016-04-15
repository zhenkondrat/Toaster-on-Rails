class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |user|
      user.permit(:login, :password, :remember_me)
    end
  end

  def set_locale
    I18n.locale = current_user.config[:locale] if user_signed_in?
  end
end
