$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"

require 'capistrano/ext/multistage'
require "whenever/capistrano"
require 'bundler/capistrano'

begin
  require 'capistrano_colors'
rescue LoadError
  puts "`gem install capistrano_colors` to get output more userfriendly."
end


set :application, "isleep"
set :repository,  "git@github.com:marsz/isleep.git"

set :scm, :git

set :stages,        %w(production)
set :default_stage, "production"

set :use_sudo, false

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :symlink_shared, :roles => [:app] do
    config_files = [:database, :facebook]
    symlink_hash = {}
    config_files.each do |fname|
      from = "#{shared_path}/config/#{fname}.yml"
      to = "#{release_path}/config/#{fname}.yml"
      run "ln -s #{from} #{to}"
    end
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  # task :copy_old_sitemap do
  #   run "if [ -e #{previous_release}/public/sitemap_index.xml.gz ]; then cp #{previous_release}/public/sitemap* #{current_release}/public/; fi"
  # end
  # 
  # task :refresh_sitemaps do
  #   run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
  # end

  # task :restart_resque, :roles => :app, :except => { :no_release => true } do
  #   pid_file = "#{current_path}/tmp/pids/resque.pid"    
  #   run "test -f #{pid_file} && cd #{current_path} && kill -s QUIT `cat #{pid_file}` || rm -f #{pid_file}"
    # run "cd #{current_path} && PIDFILE=#{pid_file} RAILS_ENV=#{rails_env} BACKGROUND=yes QUEUE=* bundle exec rake environment resque:work"
  # end
  
end

task :tail_log, :roles => :app do
  run "tail -f -n 100 #{shared_path}/log/#{rails_env}.log"
end

# task :location, :roles => :app do
#   run "cd #{current_path}; bundle exec rake dev:location RAILS_ENV=#{rails_env}"
# end

# symlink_shared
before "bundle:install", "deploy:symlink_shared"
# cleanup
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"

# sitemap
# after "deploy:update_code", "deploy:copy_old_sitemap"
# after "deploy", "deploy:refresh_sitemaps"
# after 'deploy:restart', 'deploy:restart_resque'