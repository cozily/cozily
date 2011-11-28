env = ENV["RAILS_ENV"] || "development"

worker_processes 4

listen "/tmp/cozily.socket", :backlog => 64

preload_app true
timeout 30
pid "/srv/cozily/shared/pids/unicorn.pid"

if env == "production"
  working_directory "/srv/cozily/current"

  user 'deploy', 'deploy'
  shared_path = "/srv/cozily/shared"

  stderr_path "#{shared_path}/log/unicorn.stderr.log"
  stdout_path "#{shared_path}/log/unicorn.stdout.log"
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "/srv/cozily/shared/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

