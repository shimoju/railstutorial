# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'railstutorial'
set :repo_url, 'https://github.com/ogidow/railstutorial.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  namespace :db do
    desc 'Create database'
    before :migrate, :create do
      on fetch(:migration_servers) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :bundle, :exec, :rake, 'db:create'
          end
        end
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'deploy static files to revproxy instance'
  task :static_files do
    run_locally do
      execute "RAILS_ENV=production bundle exec rake assets:precompile assets:clean"
    end
    on roles(:revproxy) do
      if test "[ -d #{deploy_to}/public ];"
        execute :rm, "-rf", "#{deploy_to}/public"
      end
      upload!('public/', "#{deploy_to}/public", recursive: true)
    end
  end
end
