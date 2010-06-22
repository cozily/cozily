# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

require 'fakeweb'
FakeWeb.allow_net_connect = false

["http://maps.google.com/maps/geo?q=546+Henry+St+11231&output=xml&key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&oe=utf-8",
 "http://maps.google.com/maps/geo?q=546+Henry+St%2C+Brooklyn%2C+NY+11231%2C+USA&output=xml&key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&oe=utf-8",
 "http://api.yelp.com/neighborhood_search?long=&lat=&ywsid=7a05VXb3EXz850ByvWF90w",
 "http://api.yelp.com/neighborhood_search?long=-74.0003197&lat=40.6824793&ywsid=7a05VXb3EXz850ByvWF90w",
 "http://maps.google.com/maps/geo?q=111+W+74th+St%2C+New+York%2C+NY+10023%2C+USA&output=xml&key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&oe=utf-8",
 "http://api.yelp.com/neighborhood_search?long=-73.978437&lat=40.779237&ywsid=7a05VXb3EXz850ByvWF90w"].each do |uri|
  FakeWeb.register_uri(:get, uri, :response => `curl -is "#{uri}"`)
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses its own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end
