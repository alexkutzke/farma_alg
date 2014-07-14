require "bundler/capistrano"
set :rvm_ruby_string, 'ruby-2.0.0-p0@farma_alg'
require "rvm/capistrano"

set :log_level, :debug


#set :whenever_command, "bundle exec whenever"
#require "whenever/capistrano"
server "192.241.202.98:2358", :web, :app, :db, primary: true
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
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :rails_env, "production"

#default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy", "deploy:ckeditor_link", "deploy:start_process_queue"


def store_pids(pids, mode)
  pids_to_store = pids
  pids_to_store += read_pids if mode == :append

  # Make sure the pid file is writable.    
  File.open(File.expand_path('tmp/pids/process_queue.pid', Rails.root), 'w') do |f|
    f <<  pids_to_store.join(',')
  end
end

def read_pids
  pid_file_path = File.expand_path('tmp/pids/proccess_queue.pid', Rails.root)
  return []  if ! File.exists?(pid_file_path)
  
  File.open(pid_file_path, 'r') do |f| 
    f.read 
  end.split(',').collect {|p| p.to_i }
end


namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop do ; end

  desc "Create ckeditor link"
  task :ckeditor_link do
    run "ln -s #{deploy_to}/shared/ckeditor_assets #{release_path}/public/ckeditor_assets"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Start the process queue"
  task :start_process_queue do
    pids = read_pids

    if pids.empty?
      puts "Process Queue was not running."
    else
      syscmd = "kill -s QUIT #{pids.join(' ')}"
      puts "$ #{syscmd}"
      `#{syscmd}`
      store_pids([], :write)
    end

    5.times do
          ops = {:err => [(Rails.root + "log/process_queue_err").to_s, "a"], 
                 :out => [(Rails.root + "log/process_queue_stdout").to_s, "a"]}

      pid = spawn({:PWD => release_path}, "rails runner --environment=production 'ProcessQueue::start'", ops)
      Process.detach(pid)
      pids << pid
    end

    store_pids(pids,:append)
  end
end
