require "bundler/capistrano"
task :hello do
  puts "Hello World"
  run "echo #{shared_path} > ~/hello"
end

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
#load "config/recipes/nodejs"
#load "config/recipes/rbenv"
load "config/recipes/check"

server "stevealex.us", :web, :app, :db, primary: true

set :user, "developer"
set :application, "ngg"
set :deploy_to, "/Users/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :launch_agents, "/Users/#{user}/Library/LaunchAgents"
set :use_sudo, false
set :server_name,"golfgaggle.com *.golfgaggle.com"
set :scm, "git"
set :repository, "git@github.com:/salex/ngg.git"

set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
