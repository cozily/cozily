desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Date.today.wday == 3 # only run on Wednesdays
    User.send_finder_summary_emails
    User.send_lister_summary_emails
  end

  Apartment.unpublish_stale_apartments
end
