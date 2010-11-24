desc "Callback before deploys"
task :before_deploy do
  puts "*" * 80
  puts "*  COMPILING COMPASS"
  puts "*" * 80

  `bundle exec compass compile`

  puts "*" * 80
  puts "*  COMPRESSING ASSETS"
  puts "*" * 80

  `bundle exec jammit --force`

  `git add public/assets && git commit -m 'updates compressed assets'`
end
