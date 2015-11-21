source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use pg as the database for Active Record
gem 'pg', '0.17.1'
# Use HAML markup language
gem 'haml', '4.0.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Bootstrap
gem 'bootstrap-sass', '~> 3.3.1'
gem 'font-awesome-rails', '4.3.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.0.3'
gem 'jquery-ui-rails', '5.0.5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Authenticate
gem 'devise', '3.4.1'
# User rights
gem 'cancancan', '~> 1.10'
# WYSIWYG
gem 'ckeditor', '4.1.1'
# File and Images attach
gem 'paperclip', '4.2.1'
# Paginate
gem 'kaminari', '0.16.3'
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
