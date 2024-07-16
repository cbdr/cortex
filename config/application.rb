require_relative 'boot'

require 'rails/all'
require 'elasticsearch/rails/instrumentation'

Bundler.require(*Rails.groups)

module Cortex
  class Application < Rails::Application
    config.angular_templates.module_name = 'cortex.templates'
    config.i18n.enforce_available_locales = true

    config.eager_load_paths += %W(#{config.root}/lib #{config.root}/lib/helpers #{config.root}/lib/breadcrumbs #{config.root}/app/models/media_types #{config.root}/app/models/post_types #{config.root}/app/models/observers)

    config.active_record.default_timezone = :utc
    config.active_record.observers = :media_observer, :post_observer, :tenant_observer, :user_observer, :youtube_observer
    config.active_job.queue_adapter = :sidekiq
    config.assets.image_optim = false
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    config.assets.paths << Rails.root.join('bower_components')

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

    # Generators should use UUID PKs by default
    config.generators do |generator|
      generator.orm :active_record, primary_key_type: :uuid
    end

    # Needed until there is a better fix for Paperclip. https://github.com/thoughtbot/paperclip/issues/1924#issuecomment-123927367
    Paperclip.options[:content_type_mappings] = {:csv => 'text/plain'}
  end
end
