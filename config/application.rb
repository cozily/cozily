require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Cozily
  class Application < Rails::Application
    %w{jobs mailers shared workers}.each do |dir|
      config.autoload_paths << Rails.root.join("app", dir)
    end

    config.autoload_paths << Rails.root.join("lib")

    config.time_zone = "Eastern Time (US & Canada)"
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end

ActionMailer::Base.default(:content_type => "text/html")
