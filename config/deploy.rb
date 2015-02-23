# config valid only for Capistrano 3.1
lock '3.2.1'

set :copy_exclude, %w(.git/* .svn/* log/* tmp/* .gitignore)
set :linked_dirs, %w{ bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads public/assets }
set :linked_files, %w{ config/mongoid.yml config/application.yml }

set :scm, "git"
set :repo_url, 'git@github.com:alexkutzke/farma_alg.git'
set :repository, 'git@github.com:alexkutzke/farma_alg.git'
#set :local_repository, "#{user}@173.246.40.9:/home/#{user}/repos/#{application}.git"
set :branch, "master"

set :rvm_ruby_version, 'ruby-2.0.0-p0@farma_alg'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
#
#  desc 'Migra todos dbs'
#  task :apartment do
#    on roles(:app) do
#      execute "cd #{release_path} && RAILS_ENV=production ~/.rvm/bin/rvm ruby-2.1.1@sigpibid do bundle exec rake apartment:migrate"
#    end
#  end
#
#  desc 'Reinicia resque workers'
#  task :restart_resque do
#    on roles(:app) do
#      execute "cd #{release_path} && RAILS_ENV=production ~/.rvm/bin/rvm ruby-2.1.1@sigpibid do bundle exec rake resque:restart_workers"
#    end
#  end
#
#  after :restart, "deploy:restart_resque"
#
#  after "deploy:migrate", "deploy:apartment"

  namespace :assets do

    Rake::Task['deploy:assets:precompile'].clear_actions

    desc 'Precompile assets locally and upload to servers'
    task :precompile do
      on roles(fetch(:assets_roles)) do
        run_locally do
          with rails_env: fetch(:rails_env) do
            execute 'RAILS_ENV=production bundle exec rake assets:precompile'
            execute 'rm -f /tmp/farma-alg-assets.tgz'
            execute 'tar cvzf /tmp/farma-alg-assets.tgz ./public/assets'
          end
        end

        within release_path do
          with rails_env: fetch(:rails_env) do
            #execute "rm -rf #{shared_path}/public/assets/*"
            upload!('/tmp/farma-alg-assets.tgz', "#{shared_path}/")
            execute "cd #{shared_path} && tar xvzf #{shared_path}/farma-alg-assets.tgz"
            execute "rm -f #{shared_path}/farma-alg-assets.tgz"
          end
        end

        #run_locally { execute 'rm -rf public/assets' }
      end
    end

  end

end

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

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
