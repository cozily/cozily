require "pony"
require "bundler/capistrano"

set :stages, %w(staging production)
set :default_stage, "staging"
require "capistrano/ext/multistage"

set :scm,             :git
set :application,     "cozily"
set :repository,      "git@github.com:cozily/cozily.git"
set :branch,          "origin/master"
set :migrate_target,  :current
set :ssh_options,     { :forward_agent => true }
set :deploy_to,       "/srv/#{application}"
set :rails_env,       defer { stage }
set :unicorn_env,     defer { stage }
set :user,            "deploy"
set :group,           "deploy"
set :use_sudo,        false

require "capistrano-unicorn"

set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }
require "whenever/capistrano"

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

set(:deploying_user_name) { `bash -c 'git config --get user.name'`.strip }
set(:deploying_user_email) { `bash -c 'git config --get user.email'`.strip }

default_run_options[:shell] = 'bash'

namespace :deploy do
  desc "Deploy your application"
  task :default do
    update
    unicorn.reload

    puts "  * Sending deployment notification."
    Pony.mail({
      :to => 'dev@cozi.ly',
      :from => 'deployments@cozi.ly',
      :subject => %Q{[Cozily] Successful deployment to #{stage} by #{deploying_user_name} (#{deploying_user_email}).},
      :via => :smtp,
      :via_options => {
        :address              => 'smtp.mailgun.org',
        :port                 => 587,
        :enable_starttls_auto => true,
        :user_name            => 'cozily@cozily.mailgun.org',
        :password             => 'marathon69',
        :authentication       => :plain,
        :domain               => "cozi.ly"
      }
    })
  end

  desc "Setup your git-based deployment app"
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end

  task :cold do
    update
    migrate
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    # transaction do
      # update_code
    # end
    update
    migrate
    unicorn.reload
  end

  task :finalize_update, :except => { :no_release => true } do
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -s #{shared_path}/system #{latest_release}/public/system &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids &&
      ln -sf #{shared_path}/config/database.yml #{latest_release}/config/database.yml
    CMD

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
      run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    end
  end

  task :notify do
  end

  desc "Generate assets with Jammit"
  task :generate_assets, :roles => :web do
    run "cd #{deploy_to}/current && bundle exec jammit"
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => { :no_release => true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end

namespace :bundler do
  task :install do
    run "sudo gem install bundler --no-rdoc --no-ri --conservative --version 1.0.21"
  end
end

namespace :homerun do
  task :install do
    run "cd #{current_path}; sudo bundle exec home_run --install"
  end
end

namespace :resque do
  task :start do
    run "sudo god start resque"
  end

  task :stop do
    run "sudo god stop resque"
  end
end

before "bundle:install", "bundler:install"
before "deploy:update", "resque:stop"
after "deploy:update", "whenever:update_crontab"
after "deploy:update", "homerun:install"
after "deploy:update", "resque:start"
after "deploy:update", "deploy:generate_assets"
after "deploy", "deploy:notify"

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end
