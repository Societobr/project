# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

require 'shellwords'

set :output, File.expand_path('../../log/cron.log', __FILE__).shellescape
# set :environment, "development"

every 1.day, at: '06:00am' do
  runner "ContatosController.send_email_expiracao"
end

# Learn more: http://github.com/javan/whenever
