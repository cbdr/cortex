# config valid for current version and patch releases of Capistrano
lock '~> 3.17.2'

set :application, 'cortex'
set :repo_url, 'https://github.com/cortex-cms/cortex.git'
set :deploy_to, "/var/www/#{fetch :application}"
set :s3_path_stage, 's3://cortex-env/Stage/.env'
set :s3_path_prod, ''

# RVM options
set :rvm1_ruby_version, "2.4.5"
set :rvm_type, :user
set :default_env, { rvm_bin_path: '~/.rvm/bin' }

# NPM options
set :npm_flags, '--silent --no-progress'    # default
set :npm_roles, :all                                     # default
set :npm_env_variables, {}                               # default
set :npm_method, 'ci'                               # default

# Sidekiq options
set :sidekiq_roles, :all
set :sidekiq_config_path, 'config/sidekiq.yml'
set :sidekiq_log_path, 'log/sidekiq.log'
set :sidekiq_pid_path, 'tmp/pids/sidekiq.pid'

before 'deploy', 'rvm1:install:rvm'
before 'deploy', 'rvm1:install:ruby'
after 'npm:install', 'remote:application_setup'
after 'deploy:publishing', 'thin:restart'
after 'deploy:publishing', 'sidekiq:restart'

# Rollback specific hooks
after 'deploy:reverting', 'remote:application_setup'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
# append :linked_files, 'start.sh'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor', 'bower_components'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
set :ssh_options, verify_host_key: :always

namespace :remote do
  desc 'Download env from S3'
  task :env_download do
    on roles(:all) do |host|
      execute "aws s3 cp #{fetch :s3_path_stage} #{fetch :release_path}/.env"
    end
  end

  desc 'Application setup'
  task :application_setup do
    on roles(:all) do |host|
      within release_path do
        execute :gem, 'update --system 3.2.3'
        execute :gem, 'install bundler -v 2.3.26'
        execute :bundle, 'install'
        execute :npm, 'install'
        execute "source #{fetch :release_path}/.env"
        execute "rm -Rf #{fetch :release_path}/public/assets/*.*"
        execute :bundle, 'exec rake assets:clean'
        execute :bundle, 'exec rake react_on_rails:assets:clobber'
        execute "cd #{fetch :release_path}; #{fetch :release_path}/node_modules/.bin/bower install angular-mocks#1.2"
        execute :bundle, 'exec rake cortex:assets:webpack:compile'
        execute :bundle, 'exec rake assets:precompile'
      end
      execute "cd #{fetch :release_path}"
    end
  end
  before :application_setup, 'rvm1:hook'
  before :application_setup, 'env_download'
end

namespace :sidekiq do
  commands = [:start, :stop, :restart]

  commands.each do |command|
    desc "sidekiq #{command}"
    task command do
      on roles(fetch(:sidekiq_roles, :app)), in: :sequence, wait: 5 do
        within current_path do
          config_file = fetch(:sidekiq_config_path)
          log_file = fetch(:sidekiq_log_path)
          pid_path = fetch(:sidekiq_pid_path)
          if [:stop, :restart].include? command
            deploy_path = fetch(:deploy_to)
            execute :bundle, "exec sidekiqctl stop #{deploy_path}/shared/#{pid_path} 0"
          end
          if [:start, :restart].include? command
            execute :bundle, "exec sidekiq -d --config #{config_file} --log #{log_file} -P #{pid_path}"
          end
        end
      end
    end
    before command, 'rvm1:hook'
  end
end
