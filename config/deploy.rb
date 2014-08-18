# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'cost'

set :scm, :git
set :repo_url, 'git@github.com:lanceyb/cost.git'
set :deploy_to, "/home/deploy/rails_apps/#{fetch(:application)}"
set :ssh_options, {
  forward_agent: true
}

set :format, :pretty
set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{public/system log tmp/pids tmp/sockets tmp/cache public/sharing}
set :pty, true
set :bundle_binstubs, nil
set :bundle_jobs, 2
set :rbenv_ruby, '2.1.2'

set :default_env, { path: "/home/deploy/.rbenv/bin:/home/deploy/.rbenv/shims:$PATH" }

namespace :deploy do
  desc 'Start application'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          uniconr_conf = "#{release_path}/config/unicorn.rb"
          execute :bundle, :exec, :unicorn_rails, "-c", uniconr_conf, "-D"
        end
      end
    end
  end

  desc "Stop application"
  task :stop do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        unicorn_pid = "#{current_path}/tmp/pids/unicorn.pid"
        execute "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`; true"
      end
    end
  end

  desc "Servers hard restart"
  task :hard_restart do
    on roles(:app) do
      invoke "deploy:stop"
      sleep 30
      invoke "deploy:start"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        unicorn_pid = "#{current_path}/tmp/pids/unicorn.pid"
        if test "[ -f #{unicorn_pid} ] "
          execute "kill -USR2 `cat #{unicorn_pid}`; true"
        else
          error "Unicorn is not running"
          exit 1
        end
      end
    end
  end

  after :publishing, :restart
end
