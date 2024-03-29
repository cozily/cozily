# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'remarkable/active_record'

Remarkable.include_matchers!(Remarkable::ActiveRecord, RSpec::Core::ExampleGroup)

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.global_fixtures = :all

  config.use_transactional_fixtures = true
end
