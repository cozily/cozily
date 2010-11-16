namespace :suite do
  task :all => ["spec", "spec:acceptance"]
end