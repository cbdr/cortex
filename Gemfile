source 'https://rubygems.org'
ruby '2.4.5'
gem 'bundler', '=2.3.26'

gem 'dotenv', '~> 2.6', '>= 2.6.0'
gem 'dotenv-rails'
# Dependency Management
gem 'bower-rails', '~> 0.11.0'

# Server
gem 'puma', '~> 3.8.2'

# Rails
gem 'rails', '~> 5.0.2'

# Cortex-specific
gem 'cortex-exceptions', '= 0.0.4'
gem 'cortex-plugins-core', '= 0.12.4'

# API
gem 'grape', github: 'saurabh-sharma-cb/grape-cortex', branch: 'v1.5.3-grape-cortex'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-entity'

# Authorization
gem 'six', '~> 0.2.0'
gem 'devise', '~> 4.8.1'
gem 'rack-oauth2', '~> 1.6.1'
gem 'doorkeeper', '~> 4.2'
gem 'rolify', '~> 5.1'
gem 'pundit', '~> 1.1'

# Data
gem 'rails-observers', git: 'https://github.com/triloch/rails-observers.git'
gem 'awesome_nested_set', git: 'https://github.com/cortex-cms/awesome_nested_set.git'
gem 'paperclip', '~> 5.1.0'
gem 'paperclip-optimizer', '~> 2.0'
gem 'image_optim_pack', '~> 0.4.0'
gem 'acts-as-taggable-on', '~> 4.0'
gem 'bcrypt', '~> 3.1.11'
gem 'kaminari', '~> 0.17.0'
gem 'grape-kaminari', '~> 0.1.9'
gem 'elasticsearch-model', '~> 5.0'
gem 'elasticsearch-rails', '~> 5.0'
gem 'paranoia', '~> 2.3'
gem 'pg', '~> 0.20.0'
gem 'hashie-forbidden_attributes', '~> 0.1.1'
gem 'redis-rails', '~> 5.0'
gem 'pomona', '~> 0.7'
gem 'transitions', '~> 1.2', require: %w(transitions active_model/transitions)
gem 'deep_cloneable', '~> 2.2.2'

# Middleware
gem 'rack-cors', '~> 0.4.1', require: 'rack/cors'

# Utility
gem 'excon', '~> 0.55.0'
gem 'hashie', '~> 3.5.5'
gem 'hashr', '~> 2.0.1'
gem 'mimemagic', '~> 0.3.9'
gem 'mime-types', '~> 3.1.0'
gem 'interactor-rails', '~> 2.0'
gem 'virtus', '~> 1.0.5'
gem 'rubyzip', '~> 1.2.1'
gem 'addressable', '~> 2.5.1'
gem 'json'

# External Services
gem 'yt', '~> 0.30.1'
gem 'aws-sdk', '~> 2.9'

# Jobs
gem 'sidekiq', '~> 5.0.0'
#gem 'sidekiq-failures', '~> 0.4.5' # Disabled until it supports sidekiq 5.x
gem 'sinatra', '~> 2.0.0.rc', require: false

# Pipeline
gem 'sprockets-rails', '3.2.0', require: 'sprockets/railtie'
gem 'sprockets', '3.7.1'
gem 'uglifier', '~> 3.2.0'
gem 'non-stupid-digest-assets', '~> 1.0.9'
gem 'angular-rails-templates', '~> 1.0.2'
gem 'ngannotate-rails', '~> 1.2.2'

# View
gem 'haml', '~> 5.0'
gem 'cells', '~> 4.1.6'
gem 'cells-rails', '~> 0.0.7'
gem 'cells-haml', '~> 0.0.10'
gem 'breadcrumbs_on_rails', '~> 3.0.1'

# Style
gem 'sass-rails', '~> 5.0'
gem 'bourbon', '~> 4.3'
gem 'font-awesome-sass', '~> 4.7.0'
gem 'material_design_lite-sass', '~> 1.3.0'

# JavaScript
gem 'react_on_rails', '< 6.6'
gem 'mini_racer', platforms: :ruby
gem 'gon', '~> 6.1.0'
gem 'turbolinks', '~> 5.0.1'
gem 'jquery-rails', '~> 4.3.1'
gem 'jquery-turbolinks', '~> 2.1'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'ng-rails-csrf', '~> 0.1.0'
gem 'bootstrap-tagsinput-rails', '~> 0.4.2'
gem 'dialog-polyfill-rails', '~> 0.4.5'

# Feature Flagging
gem 'flipper', '< 0.11'
gem 'flipper-ui', '< 0.11'
gem 'flipper-active_record', '< 0.11'
gem 'foreman'
gem 'thin'

group :tasks do
  # Parsing
  gem 'nokogiri'
end

group :test, :development do
  # Environment
  # gem 'dotenv-rails', :require => 'dotenv/rails-now'

  # Cache/Sidekiq
  gem 'redis-namespace'

  # Debug
  gem 'byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-remote'
  gem 'pry-stack_explorer'

  # Documentation
  gem 'rails-erd'
end

group :test do
  # Rspec
  gem 'rspec-rails', '~> 3.5'
  gem 'json_spec', '~> 1.1'
  gem 'rspec-sidekiq', '~> 3.0'
  gem 'shoulda-matchers', '~> 3.1'

  # Coverage
  gem 'simplecov', '~> 0.14', require: false
  gem 'codeclimate-test-reporter', '~> 0.6', require: false

  # Capybara for feature testing, Poltergeist for PhantomJS
  gem 'capybara'
  gem 'poltergeist'

  # Guard
  gem 'guard-rspec', '~> 4.7'

  # Mocking/Faking
  gem 'mocha', '~> 1.2', require: false
  gem 'database_cleaner', '~> 1.5'
  gem 'timecop', '~> 0.8'
  gem 'email_spec'

  # Javascript
  gem 'guard-jasmine', '~> 2.1'
  gem 'jasmine-core', '~> 2.5'

  # Data
  gem 'elasticsearch-extensions', '~> 0.0.26'
end

group :test, :development do
  gem 'factory_girl_rails', '~> 4.8'
  gem 'faker', '~> 1.7'
  gem 'fog-local', '~> 0.3.1'
  gem 'phantomjs', '~> 2.1.1'
  gem 'jasmine-rails', '~> 0.14'
end

group :staging, :production do
  # Monitoring
  gem 'appoptics_apm'
  gem 'sentry-raven'

  # Performance
  gem 'bootscale', require: false
end

group :development do
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.3', require: false
  gem 'ed25519', '~> 1.3'
  gem 'bcrypt_pbkdf', '~> 1.1'
  gem 'rvm1-capistrano3', require: false
  gem 'capistrano-npm'
  gem 'capistrano-thin', '~> 2.0.0'
  # Environment variable autoload from .env
  # gem 'dotenv', '~> 2.6', '>= 2.6.0'
end
