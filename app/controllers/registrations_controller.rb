class RegistrationsController < Devise::RegistrationsController

  # POST /resource
  def create
    tokens = InviteCode.local
    case params[:token]
    when tokens[:user]
      params[:user][:admin] = false
      super
    when tokens[:admin]
      params[:user][:admin] = true
      super
    else
      flash[:error] = 'Invite code is invalid'
      redirect_to new_user_registration_path
    end
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