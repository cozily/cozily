desc "Callback before deploys"
task :before_deploy do
  `bundle exec compass compile`
  `bundle exec jammit --force`

  status = `git status`
  if status =~ /public\/assets/
    puts "** You have uncommitted changes to compressed assets"
    puts "** Aborting deploy"
    raise
  end
end
