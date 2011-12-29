namespace :cron do
  desc "Run daily cron tasks"
  task :daily => :environment do
    if Date.today.wday == 3 # only run on Wednesdays
      User.send_finder_summary_emails
      User.send_lister_summary_emails
    end

    Apartment.unpublish_stale_apartments
  end
end
