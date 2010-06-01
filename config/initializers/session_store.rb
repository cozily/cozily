# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cozily_session',
  :secret      => '2ec15d2aa3fc3c6181e55f961eabc6acc20afaed1072439e78494bf06acdabd3a38c327fec9af25c672a1ad77c71217e9c8009b2e1cb8e59ead6161eaa7333eb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
