require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'

if defined?(ActiveRecord::Base)
  begin
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
  rescue LoadError => ignore_if_database_cleaner_not_present
  end
end

Spec::Runner.configure do |config|
  config.include Capybara
  config.before(:all) do
    Fixtures.reset_cache
    fixtures_folder = File.join(RAILS_ROOT, 'spec', 'fixtures')
    fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
    Fixtures.create_fixtures(fixtures_folder, fixtures)
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
