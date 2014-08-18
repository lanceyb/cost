RAILS_ROOT = File.expand_path("../..", __FILE__)
ENV["RACK_ENV"] = ENV["RAILS_ENV"] ||= "production"

preload_app true
working_directory RAILS_ROOT
pid "#{RAILS_ROOT}/tmp/pids/unicorn.pid"
stderr_path "#{RAILS_ROOT}/log/unicorn.err.log"
stdout_path "#{RAILS_ROOT}/log/unicorn.out.log"

# deploy fail so comment it
#listen 9995, :tcp_nopush => false

listen "#{RAILS_ROOT}/tmp/sockets/unicorn.sock"
worker_processes ENV["RAILS_ENV"] == "production" ? 8 : 1
timeout 120

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = File.join RAILS_ROOT, "Gemfile"
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = File.join RAILS_ROOT, "tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
  child_pid = server.config[:pid].sub(".pid", ".#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end
