set :rails_env, "staging"

role :web, "97.107.137.30"
role :app, "97.107.137.30"
role :db,  "97.107.137.30", :primary => true
