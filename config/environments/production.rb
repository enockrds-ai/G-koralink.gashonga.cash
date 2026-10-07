require_relative "../application"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.log_level = :info
  config.force_ssl = ENV["FORCE_SSL"] == "true"
  config.secret_key_base = ENV.fetch("SECRET_KEY_BASE")
end
