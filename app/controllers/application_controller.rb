class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :set_locale
  respond_to :json

  protected

  def set_locale
    I18n.locale = current_user.config[:locale] if user_signed_in?
  end
end
