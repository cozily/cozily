namespace :suite do
  task :all => ["spec", "spec:acceptance", "cucumber"]
end