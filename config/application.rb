require File.expand_path('../boot', __FILE__)

require "rails"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'rails/test_unit/railtie'
require "sprockets/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Carrie
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.time_zone = "Brasilia"
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml").to_s]
    config.i18n.default_locale = "pt-br"

    config.encoding = "utf-8"

    config.filter_parameters += [:password]

    config.assets.enabled = true
    config.assets.version = '1.0.3'
  end
end
