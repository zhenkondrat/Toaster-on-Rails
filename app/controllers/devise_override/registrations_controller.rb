class DeviseOverride::RegistrationsController < Devise::RegistrationsController

  # POST /resource
  def create
    tokens = InviteCode.get(:all)
    return redirect_to(new_user_registration_path, error: 'Invite code is invalid') unless tokens.values.include? params[:token]
    tokens.select{|role, code| code == params[:token]}.keys.first
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)
      .push(:login,
            :password,
            :password_confirmation,
            :first_name,
            :last_name,
            :father_name,
            :admin,
            :token
      )
  end
end