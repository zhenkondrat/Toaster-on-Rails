module DeviseOverride
  class RegistrationsController < Devise::RegistrationsController
    include Roles

    def create
      unless [ROLE_TEACHER, ROLE_STUDENT].include? sign_up_params[:role]
        redirect_to(new_user_registration_path, error: 'role is invalid')
        return
      end
      super
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer
        .for(:sign_up)
        .push(
          :email,
          :login,
          :password,
          :password_confirmation,
          :first_name,
          :last_name,
          :father_name,
          :role,
          :token
        )
    end
  end
end
