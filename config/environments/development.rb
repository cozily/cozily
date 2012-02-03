Cozily::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local = true
  config.action_view.debug_rjs = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.perform_deliveries = :true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :host => "localhost", :port => 1025 }

  FACEBOOK_APP_ID = "222311754528494"
  FACEBOOK_APP_SECRET = "274c15daf1839090384eef9bdb1986d4"
end

