# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'menunote'
set :repo_url, 'git@github.com:xofanf/menunote.git'

# Default branch is :master
set :branch, "master"

# Set the user you want to use for your server's deploys
set :user, "terry"

# Commands are executed with the user's permissions unless specified
set :use_sudo, false

# Set your target deployment environment
set :rails_env, "production"

# How you'd like to make updates
set :deploy_via, :remote_cache

# Special SSH options
set :ssh_options, { :forward_agent => true, :port => 3000 }

# Domain name
server "www.foodienote.com", roles: [:app, :web, :db]

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
 set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
