Carrie::Application.configure do

  require 'yaml'

  yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'application.yml'))).result)
  APP_CONFIG = HashWithIndifferentAccess.new(yaml_data)

  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.precompile += %w(html5.js)
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.action_mailer.default_url_options = { :host => APP_CONFIG[:default_url_options][:host] }

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  #config.assets.precompile += %w( application2.js panel/*.js panel.js login.js dashboard/*.js )
  #config.assets.precompile += Ckeditor.assets
  config.assets.precompile = ['*.js', '*.css', '*.png', '*.jpg', '*.ttf', '*.eot', '*.svg', '*.woff']
  config.assets.paths << "#{Rails}/vendor/assets/fonts"

  #config.assets.precompile = [ method(:compile_asset?).to_proc ]

  # config.assets.precompile << Proc.new { |path|
    # if path =~ /\.(css|js)\z/
      # full_path = Rails.application.assets.resolve(path).to_path
      # app_assets_path = Rails.root.join('app', 'assets').to_path
      # vendor_assets_path = Rails.root.join('vendor', 'assets').to_path

      # if ((full_path.starts_with? app_assets_path) || (full_path.starts_with? vendor_assets_path)) && (!path.starts_with? '_') && (!path.include?("AdminLTE/plugins/ckeditor"))
        # puts "\t" + full_path.slice(Rails.root.to_path.size..-1)
        # true
      # else
        # false
      # end
    # else
      # false
    # end
  # }

  #config.assets.precompile += ['app/assets/javascripts/*.js']

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  # config.serve_static_assets = true # to try production on local machine


  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.use_jailkit = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'urquell.c3sl.ufpr.br',
    domain:               'c3sl.ufpr.br',
    openssl_verify_mode:  'none'
  }
  
end
