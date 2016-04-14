module DeviseOverride
  class RegistrationsController < Devise::RegistrationsController

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer
        .for(:sign_up)
        .push(
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
