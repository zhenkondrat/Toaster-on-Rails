class DeviseOverride::SessionsController < Devise::SessionsController
  after_filter :after_login, only: :create

  def after_login
    I18n.locale = current_user.config[:locale]
  end
end
