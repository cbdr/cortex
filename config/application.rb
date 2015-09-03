require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'elasticsearch/rails/instrumentation'
Bundler.require(:default, Rails.env)

module Cortex
  class Application < Rails::Application
    config.angular_templates.module_name = 'cortex.templates'
    config.i18n.enforce_available_locales = true
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/models/media_types #{config.root}/app/models/post_types #{config.root}/app/models/observers)
    config.active_record.default_timezone = :utc
    config.active_record.observers = :media_observer, :post_observer, :tenant_observer, :user_observer, :youtube_observer
    config.active_job.queue_adapter = :sidekiq
    config.assets.image_optim = false

    ActsAsTaggableOn.remove_unused_tags = true
    ActsAsTaggableOn.force_lowercase = true

    # Insert Rack::CORS as the first middleware
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins *((Cortex.config.cors.allowed_origins || '*').split(',') +
                  [Cortex.config.cors.allowed_origins_regex || ''])
        resource '*',
                 :headers => :any,
                 :expose  => %w(Content-Range Link),
                 :methods => [:get, :post, :options, :put, :patch, :delete]
      end
    end

    require 'rack/oauth2'
    config.middleware.use Rack::OAuth2::Server::Resource::Bearer, 'OAuth2' do |request|
      Doorkeeper::AccessToken.authenticate(request.access_token) || request.invalid_token!
    end

    config.generators do |generator|
      generator.orm :active_record
    end

    # Needed until there is a better fix for Paperclip. https://github.com/thoughtbot/paperclip/issues/1924#issuecomment-123927367
    Paperclip.options[:content_type_mappings] = {:csv => 'text/plain'}

    # Mailgun Setup
    config.action_mailer.delivery_method = :mailgun

    config.action_mailer.mailgun_settings = {
        api_key: 'key-8254457a35032983871f58bcff1c4434',
        domain: 'sandbox0d945873f5574fddaf00af756dbbc1e0.mailgun.org'
      }
      
  end
end
