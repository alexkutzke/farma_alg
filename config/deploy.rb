require "bundler/capistrano"
set :rvm_ruby_string, 'ruby-2.0.0-p0@farma_alg'
require "rvm/capistrano"

set :log_level, :debug

set :ssh_options, {
  port: 2358
}

#set :whenever_command, "bundle exec whenever"
#require "whenever/capistrano"
server "192.241.202.98", :web, :app, :db, primary: true
#server "107.170.214.146:2358", :web, :app, :db

set :user, "alex"
set :application, "farma-alg"
set :deploy_to, "/home/#{user}/dev/#{application}"
#set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repo_url, 'git@github.com:alexkutzke/farma_alg.git'
set :repository, 'git@github.com:alexkutzke/farma_alg.git'
#set :local_repository, "#{user}@173.246.40.9:/home/#{user}/repos/#{application}.git"
set :branch, "master"

set :copy_exclude, %w(.git/* .svn/* log/* tmp/* .gitignore)
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads }
set :linked_files, %w{ config/mongoid.yml }

set :rails_env, "production"

#default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy", "deploy:ckeditor_link", "deploy:start_process_queue"

def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')

  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end


namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop do ; end

namespace :assets do
  desc "Precompile assets locally and then rsync to app servers"
  task :precompile, :only => { :primary => true } do
    run_locally "mkdir -p public/__assets; mv public/__assets public/assets;"
    run_locally "bundle exec rake assets:clean_expired; RAILS_ENV=production bundle exec rake assets:precompile;"
    servers = find_servers :roles => [:app], :except => { :no_release => true }
    servers.each do |server|
      run_locally "rsync -av --progress --inplace --rsh='ssh -p2358' ./public/assets/ #{user}@#{server}:#{current_path}/public/assets/;"
    end
    run_locally "mv public/assets public/__assets"
  end
end


  # namespace :assets do
    # task :precompile, :roles => :web, :except => { :no_release => true } do
      #  from = source.next_revision(current_revision)
      #  if releases.length <= 1 || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        #  run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      #  else
        #  logger.info "Skipping asset pre-compilation because there were no asset changes"
      #  end
  #  end
  # end

  desc "Create ckeditor link"
  task :ckeditor_link do
    run "ln -s #{deploy_to}/shared/ckeditor_assets #{release_path}/public/ckeditor_assets"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

#  desc "Start the process queue"
#  task :start_process_queue do
#    run_remote_rake "process_queue:start_server"
#  end
end
