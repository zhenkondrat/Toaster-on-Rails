lock '3.3.5'

set :rails_env, 'production'
set :unicorn_env, 'production'
set :application, 'toaster'
set :rails_env, 'production'
set :domain, 'deployman@146.185.189.234'
set :deploy_to, '/home/deployman/toaster'
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rvm_ruby_version, '2.2.0'
set :rvm_type, :user
set :rvm_path, '~/.rvm'

set :scm, :git
set :repo_url, 'git@github.com:elhowm/Toaster-on-Rails.git'
set :branch, 'master'
set :deploy_via, :remote_cache

role :web, 'deployman@146.185.189.234'
role :app, 'deployman@146.185.189.234'
role :db, 'deployman@146.185.189.234', :primary => true

set :linked_files, %w{config/database.yml}
set :linked_dirs, fetch(:linked_dirs, []) + %w(public/ckeditor_assets public/parser)

namespace :unicorn do
  task :restart do
    on roles(:all) do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -USR2 `cat #{fetch(:unicorn_pid)}`; else cd #{release_path} && /home/deployman/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec unicorn_rails -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D; fi"
    end
  end

  task :start do
    on roles(:all) do
      execute "cd #{release_path} && /home/deployman/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec unicorn_rails -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D"
    end
  end

  task :stop do
    on roles(:all) do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end
end

namespace :folders do
  task :prepare do
    on roles(:all) do
      execute "chmod 775 #{release_path}/public/parser"
      execute "chmod 775 #{release_path}/public/ckeditor_assets"
    end
  end
end

after 'deploy', 'unicorn:restart'
