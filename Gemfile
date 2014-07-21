source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.1.2'

def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

# Rails
gem 'rails', '~> 4'

# API
gem 'grape', '~> 0.7'
gem 'grape-entity'
gem 'grape-swagger'
gem 'doorkeeper', git: 'git://github.com/applicake/doorkeeper'

# Templating
gem 'haml'

# Style
gem 'sass-rails', '~> 4'
gem 'font-awesome-sass'

gem 'sprockets'

# JS
gem 'ng-rails-csrf'
gem 'angular-rails-templates'
gem 'gon'
gem 'jquery-rails'
gem 'momentjs-rails'
gem 'ngmin-rails'
gem 'therubyracer'
gem 'turbolinks'
gem 'uglifier'
gem 'underscore-rails'

gem 'rails-assets-angular', '~> 1.2'
gem 'rails-assets-angular-animate'
gem 'rails-assets-angular-sanitize'
gem 'rails-assets-angular-resource'
gem 'rails-assets-angular-cookies'

gem 'rails-assets-angular-ui-router', '~> 0.2'
gem 'rails-assets-angular-bootstrap', '~> 0.11'
gem 'rails-assets-angular-flash'
gem 'rails-assets-angular-bootstrap-datetimepicker'
gem 'rails-assets-angular-redactor-patched'
gem 'rails-assets-angularjs-file-upload'
gem 'rails-assets-ng-table'
gem 'rails-assets-bootstrap-sass-official'
gem 'rails-assets-ng-tags-input'
gem 'rails-assets-angular-bootstrap-switch'

# ActiveRecord
gem 'rails-observers'
gem 'awesome_nested_set', '~> 3.0.0.rc.5'
gem 'paperclip', '~> 4.1'
gem 'acts-as-taggable-on', '~> 3.2'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'elasticsearch-model', '~> 0.1'
gem 'elasticsearch-rails', '~> 0.1'
gem 'kaminari'
gem 'sanitize', '~> 3.0'
gem 'paranoia', '~> 2.0'
gem 'pg'

# Mongoid
gem 'mongoid', '~> 4.0.0.rc2', git: 'git://github.com/mongoid/mongoid'
gem 'bson_ext'
gem 'mongoid-paranoia', github: 'simi/mongoid-paranoia'

# Authorization
gem 'six'
gem 'devise'
gem 'rack-oauth2'

# Utility
gem 'foreman', require: false
gem 'fog'
gem 'unf'
gem 'hashr'
gem 'mime-types'
gem 'json'

# Middleware
gem 'rack-cors', require: 'rack/cors'

# Sidekiq
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sinatra', require: false
gem 'slim' # Sidekiq-web

group :test, :development, :local do

  # Rspec
  gem 'rspec', '~> 2.99'
  gem 'rspec-rails'
  gem 'json_spec'

  # Guard
  gem 'guard-rspec'

  # Shoulda needs minitest
  gem 'minitest'

  # Mocking/Faking
  gem 'mocha', require: false
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'shoulda'
  gem 'shoulda-matchers'

  # Notifications
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'growl', require: darwin_only('growl')
  gem 'rb-inotify', require: linux_only('rb-inotify')

  # Pretty
  gem 'pry'
  gem 'awesome_print'

  # IDE
  gem 'ruby-debug-ide', require: false

  gem 'jasmine-rails'
  gem 'guard-jasmine'
  gem 'jasmine-core', '~> 1.3'
  gem 'rails-assets-angular-mocks'
end

group :development do
  # Pretty
  gem 'better_errors'
  gem 'annotate'
  gem 'binding_of_caller'

  # Coverage
  gem 'rails_best_practices'

  # Server
  gem 'thin'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'timecop'
  gem 'rspec-sidekiq'
  gem 'elasticsearch-extensions'
end

group :assets do
  gem 'coffee-rails'
end

group :production do
  gem 'aws-sdk'
end
