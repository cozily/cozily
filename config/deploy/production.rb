set :rails_env, "production"

role :web, "208.85.150.121"
role :app, "208.85.150.121"
role :db,  "208.85.150.121", :primary => true
