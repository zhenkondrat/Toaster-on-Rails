class ChangeLanguageService
  def initialize(user)
    @user = user
  end

  def change!(language)
    if language_is_valid? language
      I18n.locale = language
      @user.update(config: {locale: language})
    else
      false
    end
  end

  private

  def language_is_valid?(language)
    I18n.locale_available?(language)
  end
end
