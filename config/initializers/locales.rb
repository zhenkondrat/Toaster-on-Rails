Rails.application.config.tap do |config|
  config.i18n.default_locale = :en
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
end
