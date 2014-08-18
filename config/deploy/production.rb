set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "master"
set :rails_env, "production"
set :whenever_environment, "production"

server 'lancezyb.com', user: 'root', roles: %w{app web db}
