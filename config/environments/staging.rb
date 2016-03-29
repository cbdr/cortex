Cortex::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  #config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  config.cache_store = :redis_store, ENV['CACHE_URL']

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  if ENV['S3_BUCKET_NAME'].to_s != ''
    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      },
      :s3_region => ENV['S3_REGION'],
      :bucket => ENV['S3_BUCKET_NAME'],
      :url => ':s3_alias_url',
      :s3_host_alias => ENV['S3_HOST_ALIAS']
    }
  else
    Paperclip.options[:command_path] = '/usr/local/bin/'
    config.paperclip_defaults = {
      storage: :fog,
      fog_host: ENV['HOST'],
      fog_directory: '',
      fog_credentials: {
        provider: 'Local',
        local_root: "#{Rails.root}/public"
      }
    }
  end

  Yt.configure do |config|
    config.log_level = :debug
    config.api_key = ENV['YOUTUBE_STG_API_KEY']
  end

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {:host => ENV['HOST']}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :authentication => :login,
    :address => ENV['SMTP_ADDRESS'],
    :port => ENV['SMTP_PORT'],
    :domain => ENV['SMTP_SENDER_DOMAIN'],
    :user_name => ENV['SMTP_USERNAME'],
    :password => ENV['SMTP_PASSWORD'],
    :enable_starttls_auto => ENV['SMTP_STARTTLS']
  }
  ActionMailer::Base.default from: ENV['SMTP_SENDER_ADDRESS']
end
