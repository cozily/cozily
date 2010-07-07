ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

require 'fakeweb'
FakeWeb.allow_net_connect = false

["http://maps.google.com/maps/geo?q=546+Henry+St+11231&output=xml&key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&oe=utf-8",
 "http://maps.google.com/maps/geo?q=151+Huron+St+11222&output=xml&key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&oe=utf-8",
 "http://maps.google.com/maps/geo?q=99+S+3rd+St+11211&output=xml&key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&oe=utf-8",
 "http://maps.google.com/maps/geo?q=111+W+74th+St+10023&output=xml&key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&oe=utf-8",
 "http://maps.google.com/maps/geo?q=268+Bowery+10012&output=xml&key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&oe=utf-8",
 "http://api.yelp.com/neighborhood_search?long=&lat=&ywsid=7a05VXb3EXz850ByvWF90w",
 "http://api.yelp.com/neighborhood_search?long=-74.0003197&lat=40.6824793&ywsid=7a05VXb3EXz850ByvWF90w",
 "http://api.yelp.com/neighborhood_search?long=-73.955389&lat=40.733134&ywsid=7a05VXb3EXz850ByvWF90w",
 "http://api.yelp.com/neighborhood_search?long=-73.963561&ywsid=7a05VXb3EXz850ByvWF90w&lat=40.713106",
 "http://api.yelp.com/neighborhood_search?long=-73.978437&lat=40.779237&ywsid=7a05VXb3EXz850ByvWF90w",
 "http://api.yelp.com/neighborhood_search?lat=40.723535&ywsid=7a05VXb3EXz850ByvWF90w&long=-73.993236",
 "http://api.yelp.com/neighborhood_search?lat=40.68244&long=-74.0003021&ywsid=7a05VXb3EXz850ByvWF90w"].each do |uri|
  FakeWeb.register_uri(:get, uri, :response => `curl -is "#{uri}"`)
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end
