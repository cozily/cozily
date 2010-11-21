# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require File.join(File.dirname(__FILE__), '../test/webmock_helper.rb')
require 'rspec/rails'
require 'remarkable/active_record'

Remarkable.include_matchers!(Remarkable::ActiveRecord, RSpec::Core::ExampleGroup)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.global_fixtures = :all

  config.use_transactional_fixtures = true
end
