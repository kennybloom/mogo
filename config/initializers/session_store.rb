# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mogo_session',
  :secret      => 'b204314459a0a25792460d2d27e9b2c3ae780c2e153c654d52f595ff1ceaf345d402a6f927d51db8da55dc90c09c7fd4c7398756a328500e474e1e2cad6e9ff6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
