require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Cozily
  class Application < Rails::Application
    ["jobs", "mailers", "shared"].each do |subdir|
      config.autoload_paths << "#{Rails.root.to_s}/app/#{subdir}"
    end
    config.autoload_paths += %W(#{config.root}/lib)

    config.time_zone = "Eastern Time (US & Canada)"
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end

ActionMailer::Base.default(:content_type => "text/html")
