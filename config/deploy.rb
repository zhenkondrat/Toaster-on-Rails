require 'capistrano/rvm'
require 'capistrano/bundler'

set :application, 'toaster'
set :rails_env, 'production'
set :domain, 'deployman@192.168.1.104'
set :deploy_to, '/home/deployman/paradise'
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rvm_ruby_string, '2.2.0'

set :scm, :git
set :repo_url, 'git@github.com:elhowm/Toaster-on-Rails.git'
set :branch, 'master'
set :deploy_via, :remote_cache

# role :all, 'deployman@192.168.1.104'
role :web, 'deployman@192.168.1.104'
role :app, 'deployman@192.168.1.104'
role :db, 'deployman@192.168.1.104', :primary => true

# before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'

# after 'deploy:update_code', roles: :app do
#   run "rm -f #{current_release}/config/database.yml"
#   run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
# end
set :linked_files, %w{config/database.yml}

namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
