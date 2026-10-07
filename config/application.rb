require "bundler/setup"
require "rails/all"
Bundler.require(*Rails.groups)
module Gkoralink
  class Application < Rails::Application
    config.load_defaults 8.0
    config.time_zone = "Africa/Kigali"
  end
end
