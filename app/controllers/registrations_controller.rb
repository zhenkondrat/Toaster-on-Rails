class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [:cancel]
  prepend_before_filter :authenticate_scope!, only: [:new, :create, :edit, :update, :destroy]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:login, :password, :admin)
  end
end