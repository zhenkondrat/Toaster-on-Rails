source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use pg as the database for Active Record
gem 'pg', '0.18.4'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# File and Images attach
gem 'paperclip', '4.2.1'
# Pagination
gem 'kaminari'
# Localization
gem 'rails-i18n', '~> 4.0.0'
# Use unicorn as the app server
gem 'unicorn', '4.8.3', group: :production

# Use Capistrano for deployment
group :development do
  gem 'capistrano-rails', '1.1.2'
  gem 'capistrano-rvm', '0.1.2'
end

group :test, :development do
  gem 'byebug'
  gem 'rspec-rails', '3.1.0'
  gem 'factory_girl_rails', '4.5.0'
  gem 'shoulda-matchers', '2.7.0', require: false
  gem 'faker'
  gem 'simplecov', require: false
end

group :test do
  gem 'nyan-cat-formatter'
  gem 'database_cleaner'
end
