desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Date.today.wday == 3 # only run on Wednesdays
    User.delay.send_finder_summary_emails
    User.delay.send_lister_summary_emails
  end

  Apartment.delay.unpublish_stale_apartments
end
