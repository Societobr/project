require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)
require 'mina_sidekiq/tasks'

set :domain, 'societo.com.br'
set :deploy_to, '/root/societo'
set :repository, 'https://github.com/cristianocasm/societo.git'
set :branch, 'master'
set :term_mode, nil
set :rvm_path, '/usr/local/rvm/scripts/rvm'
set :rails_env, 'production'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
set :user, 'root'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.0.0-p481@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails_db_migrate_production'
    invoke :'rails_assets_precompile_production'

    to :launch do
      #queue "RAILS_ENV=production bundle exec rake db:migrate"
      # queue "RAILS_ENV=production bundle exec rake assets:precompile"
      queue "touch #{deploy_to}/tmp/restart.txt"
      # queue "rvmsudo thin start -e production --threaded -p 80"
      queue "RAILS_ENV=production rails server thin -d -p 80"
      invoke :'sidekiq:restart'
    end
  end
end

  task :rails_db_migrate_production do
    queue "RAILS_ENV=production bundle exec rake db:migrate"
  end

  task :rails_assets_precompile_production do
    queue "RAILS_ENV=production bundle exec rake assets:precompile"
  end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

