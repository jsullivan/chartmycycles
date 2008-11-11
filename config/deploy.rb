#Set application name, deployment location on the remote server, SSH options, SCM options :
set :application, "chartmycycles"
# deploy_to : location of the application on the remote deployment server .
# Create this folder before cap deploy.
set :deploy_to, "/var/www/my_app"
set :scm, "git"
set :repository,  "git@github.com:jsullivan/chartmycycles.git"
set :branch, "master"
default_run_options[:pty] = true
set :ssh_options, { :forward_agent => true }
set :user, "josh"
role :app, "dipperstove.com"
role :web, "dipperstove.com"
role :db,  "dipperstove.com", :primary => true
set :deploy_via, :remote_cache
