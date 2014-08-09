def store_pids(pids, mode)
  pids_to_store = pids
  pids_to_store += read_pids if mode == :append

  # Make sure the pid file is writable.
  File.open(File.expand_path('tmp/pids/process_queue.pid', Rails.root), 'w') do |f|
    f <<  pids_to_store.join(',')
  end
end

def read_pids
  pid_file_path = File.open(File.expand_path('tmp/pids/process_queue.pid', Rails.root),'a')
  return []  if ! File.exists?(pid_file_path)

  File.open(pid_file_path, 'r') do |f|
    f.read
  end.split(',').collect {|p| p.to_i }
end

namespace :process_queue  do
	task :start_server => :environment do
    pids = read_pids

    if pids.empty?
      puts "Process Queue was not running."
    else
      syscmd = "kill -s QUIT #{pids.join(' ')}"
      puts "$ #{syscmd}"
      `#{syscmd}`
      store_pids([], :write)
    end

    clean = "pkill cpulimit"
    puts "$ #{clean}"
    `#{clean}`

    pids = read_pids
    1.times do
          ops = {:err => [(Rails.root + "log/process_queue_err").to_s, "a"],
                 :out => [(Rails.root + "log/process_queue_stdout").to_s, "a"]}

      pid = spawn({}, "rake --environment=production process_queue:start", ops)
      Process.detach(pid)
      pids << pid
      cpulimit = "cpulimit -p #{pid} -l 50 -b"

      puts "$ #{cpulimit}"
      `#{cpulimit}`
    end

    store_pids(pids,:append)
	end


  task :start => :environment do
    ProcessQueue::start
  end
end
