RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
require 'geokit'

Rails::Initializer.run do |config|
  ["mailers", "shared"].each do |subdir|
    config.autoload_paths << "#{RAILS_ROOT}/app/#{subdir}"
  end

  config.time_zone = 'Eastern Time (US & Canada)'
end

ActionMailer::Base.default_content_type = "text/html"

