# Cortex CMS [![Build Status](https://semaphoreci.com/api/v1/projects/ec90715a-da8f-4960-bb64-f371850f9c98/813409/shields_badge.svg)](https://semaphoreci.com/content-enablement/cortex) [![Code Climate](https://codeclimate.com/repos/53f62c2869568018180036c9/badges/78e3c3c865b118bbd72b/gpa.svg)](https://codeclimate.com/repos/53f62c2869568018180036c9/feed) [![Test Coverage](https://codeclimate.com/repos/53f62c2869568018180036c9/badges/78e3c3c865b118bbd72b/coverage.svg)](https://codeclimate.com/repos/53f62c2869568018180036c9/coverage) [![Documentation Status](https://readthedocs.org/projects/cortex-cms/badge/?version=latest)](http://docs.cbcortex.com/en/latest/?badge=latest)

<img align="right" height="150"
     src="https://hiring-assets.careerbuilder.com/branding/cortex-logo.svg"
     alt="Cortex CMS Logo">

Cortex CMS is a [multitenant](https://en.wikipedia.org/wiki/Multitenancy) identity, content distribution/management and reporting platform built by the [Content Enablement][cb-ce-github] team at [CareerBuilder](https://github.com/careerbuilder). Its purpose is to provide central infrastructure for next-generation applications; exposing a single point of management while enabling quicker build-out of new software.

Cortex follows a decentralized, API-only architecture - it is *not* built like Wordpress or Drupal, which are considered monolithic, all-in-one solutions.

## Table of Contents

- [Setup](#setup)
  - [Environment](#environment)
  - [Dependencies](#dependencies)
    - [System](#system)
      - [OS X](#os-x)
      - [Linux](#linux)
    - [Application](#application)
  - [Database](#database)
  - [Server](#server)
  - [Deployment](#deployment)
- [Running Test Suite](#running-test-suite)
- [API](#api)
  - [Documentation](#documentation)
  - [Resources](#resources)
    - [Tenants](#tenants)
    - [Users](#users)
    - [Media](#media)
    - [Posts](#posts)
    - [Categories](#categories)
    - [Occupations](#occupations)
    - [Localizations](#localizations)
    - [Applications](#applications)
    - [Bulk Jobs](#bulk_jobs)
    - [Documents](#documents)
    - [Snippets](#snippets)
    - [Webpages](#webpages)
- [Consuming Cortex](#consuming-cortex)
  - [Authorization](#authorization)
  - [Content](#content)
  - [Localizations](#localizations)
  - [Webpages and Snippets](#webpages-and-snippets)
  - [Exceptions](#exceptions)
- [Applications Using Cortex](#applications-using-cortex)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Copyright](#copyright)

## Setup

### Environment

Copy and rename the example `.env.example` file as `.env` and modify it to match your environment.

For a rudimentary setup, these variables should be configured:

* Execute `$ bundle exec rails secret` twice to generate both an `APP_SECRET` and `DEVISE_SECRET`
* If the superuser isn't used for the app databases, the `DATABASE_USERNAME` and `DATABASE_PASSWORD` should be set accordingly.
* Set `HOST` to the local Web server's root URL to properly configure Fog (local asset storage)

### Dependencies

#### System

##### OS X

* Install the Xcode Command Line tools:

```sh
$ xcode-select --install
```

* Install all Cortex system-wide dependencies (and the `readline` Ruby/`byebug` build dependency) using [Homebrew](http://brew.sh/) from the `Brewfile` via `$ brew install $(cat Brewfile|grep -v "#")`
* Install Ruby via [rbenv](https://github.com/sstephenson/rbenv) or [rvm](https://rvm.io/).
* Enable system agents:

```sh
$ ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
$ ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
$ ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
```

and start them with `brew services`:

```sh
$ brew services start postgresql
$ brew services start elasticsearch
$ brew services start redis
```

or `launchctl`:

```sh
$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
```

##### Linux

* Install all Cortex system-wide dependencies (and the `readline` Ruby/`byebug` build dependency) using your distribution's package manager (`pacman`, `apt-get`, `yum`, etc). For example, with Ubuntu's `apt-get`:

```sh
$ apt-get install libreadline6-dev postgresql postgresql-contrib redis-server openjdk-8-jre imagemagick jpegoptim ghostscript
```

Ubuntu and Redhat/Fedora do not have an official `elasticsearch` package - you must use Elasticsearch's [repository](https://www.elastic.co/blog/apt-and-yum-repositories) or follow these [instructions](https://github.com/elastic/elasticsearch#installation). The same goes for `phantomjs`. Build from [source](http://phantomjs.org/download.html) or use a [PPA](https://launchpad.net/ubuntu/+ppas?name_filter=phantomjs). Other Linux distributions likely have these as prebuilt packages in their official or user repositories.

* Install Ruby via [rbenv](https://github.com/sstephenson/rbenv) or [rvm](https://rvm.io/).
* Enable system agents using your distribution's service manager frontend, which is likely `systemd`'s frontend, `systemctl`:

```sh
$ systemctl enable postgresql
$ systemctl enable elasticsearch
$ systemctl enable redis
```

and start them with `systemctl`:

```sh
$ systemctl start postgresql
$ systemctl start elasticsearch
$ systemctl start redis
```

#### Application

* Install Bundler and its dependencies:

```sh
$ gem install bundler && bundle install
```

* Install `node` dependencies (including `bower`) and use `bower-rails`'s rake task to install dependencies:

```sh
$ npm install && bundle exec rake bower:install:development
```

### Database

* Create databases:

```sh
$ bundle exec rake db:create
```

* Initialize the schema:

```sh
$ bundle exec rake db:schema:load
```

* Seed database with a top-level tenant, the superuser, Advice & Resources categories, ONET occupation/industry codes, and Custom Content data, then rebuild the ElasticSearch index:

```sh
$ bundle exec rake db:seed
$ bundle exec rake cortex:create_categories
$ bundle exec rake cortex:onet:fetch_and_provision
$ bundle exec rake cortex:core:db:reseed
$ bundle exec rake cortex:rebuild_indexes
```

### Server

Start Cortex, Sidekiq and live rebuild of Webpack scripts via Foreman:

```sh
$ foreman start -f Procfile.dev
```

The admin interface should now be accessible locally on port `3000`. To access Cortex as superadmin, login as `admin@cortexcms.org` with password `welcome1`.

### Deployment

Capistrano is used to deploy the application.
It requires the IP address for the server and the pem keyfile for access.
Following configuration is required:

1. Edit 'config/deploy/staging.rb' and set the following values:
```
set :staging_ip, '<SET THE IP ADDRESS HERE>'
set :staging_key_path, '<SET THE ABSOLUTE KEY PATH HERE>'
```
2. Capistrano commands mini-cheatsheet
```
# Deploy the application
cap staging deploy

# Restart thin web-server
cap staging thin:restart

# Restart Sidekiq
cap staging sidekiq:restart

# Rollback to the previous version
cap staging deploy:rollback
```

Analogous changes can be done for production environment.

## Running Test Suite

Initialize the test database:

```sh
$ RAILS_ENV=test bundle exec rake db:schema:load db:seed cortex:create_categories cortex:onet:fetch_and_provision cortex:core:db:reseed
$ RAILS_ENV=test bundle exec rake cortex:rebuild_indexes
```

To run Ruby and JS specs, utilize:

```sh
$ RAILS_ENV=test bundle exec rake spec
$ RAILS_ENV=test bundle exec rake spec:javascript
```

## API

### Documentation

Cortex's live API documentation is available via Swagger. This contains specific endpoints, parameters, and response models.

SwaggerUI is provided at [http://docs.api.cbcortex.com/](http://docs.api.cbcortex.com).

Swagger Endpoints are available at [http://api.cbcortex.com/api/v1/swagger_doc.json](http://api.cbcortex.com/api/v1/swagger_doc.json).

### Resources

Note: most resources are treated as 'paranoid' - that is, data is never truly deleted in the system - only archived.

#### [Tenants](http://docs.api.cbcortex.com/#!/tenants)

Tenants act as a nested set and are the foundation of the channel-focused content distribution mechanism of Cortex, and allow data to be segregated throughout the system. Tenancy is currently very limited in scope. For example, users are directly tied to a tenant, and content can only be associated with a tenant via an inflexible `content -> user -> tenant` relationship. This will be expanded soon.

#### [Users](http://docs.api.cbcortex.com/#!/users)

Users are for authorization and authentication. They currently lack roles, except for the ability to enable/disable admin access.

#### [Media](http://docs.api.cbcortex.com/#!/media)

Media covers any potential file-type to be stored in or linked to by the Cortex. This includes:

* Images
* Audio
* Video
* Youtube Links
* Documents
* Text

When Media is consumed anywhere within the system, the two pieces of content become tied, and the Media cannot be deleted without the reference removed in the consuming piece of content.

#### [Posts](http://docs.api.cbcortex.com/#!/posts)

Posts serve as a packaged distribution medium consisting of other content. They can be categorized, assigned to an occupation, and contain media of any format.

The posts endpoint also includes other posts-specific functionality, such as post filters and post tags.

#### [Categories](http://docs.api.cbcortex.com/#!/categories)

Categories act as a nested set, living in a tree-like structure with parents and children. Cortex's API provides both this hierarchy and a flat list of categories, with a minimum depth as an optional parameter. These are currently unable to be manipulated via the admin interface, only directly within the database.

#### [Occupations](http://docs.api.cbcortex.com/#!/occupations)

Occupations act as a nested set of Industries with specific Occupations (with SOC codes) beneath them. They utilize the ONET database, and are intended to eventually power intelligent content recommendations. See the `cortex:onet` rake task for specifics.

#### [Localizations](http://docs.api.cbcortex.com/#!/localizations)

Localizations/locales provide YAML/JSON-formatted translations for consuming applications.

#### [Applications](http://docs.api.cbcortex.com/#!/applications)

Applications contain credentials for OAuth applications that consume Cortex.

#### [Bulk Jobs](http://docs.api.cbcortex.com/#!/bulk_jobs)

Bulk Jobs is the generic interface for uploads processed in bulk for any compatible resource, i.e. `users`, `posts` and `media`.

#### [Documents](http://docs.api.cbcortex.com/#!/documents)

Documents are an incredibly generic piece of content, consisting only of raw text. They are intended to be made more specific by other resources, i.e. `snippets` and `webpages`.

#### [Snippets](http://docs.api.cbcortex.com/#!/snippets)

Snippets build ontop of a generic Document, and are intended to be HTML sections on a webpage.

#### [Webpages](http://docs.api.cbcortex.com/#!/webpages)

Webpages group together `snippets`, and correspond to a destination URL, and contain various additional metadata to power a dynamic, editable webpage.

## Consuming Cortex

### Authorization

Cortex's API utilizes [OAuth2](https://tools.ietf.org/html/rfc6749) for Authentication and Authorization. Client Credentials and Authorization Code [grant types](http://alexbilbie.com/2013/02/a-guide-to-oauth-2-grants/) are supported. Want to get up and running quickly with OAuth? Use Cortex's [Ruby client](https://github.com/cortex-cms/cortex-client-ruby) or [OmniAuth strategy](https://github.com/cb-talent-development/omniauth-cortex) for Client Credentials and Authorization Code grants, respectively.

Review the `optional_scopes` in Cortex's [Doorkeeper config](https://github.com/cbdr/cortex/blob/master/config/initializers/doorkeeper.rb) to determine the available scopes, and the [API Resource classes](https://github.com/cbdr/cortex/tree/master/app/api/v1/resources) to determine where they're required.

Before an application can consume any data, OAuth credentials must be created for the consuming application in the 'Applications' section of the Cortex admin interface.

### Content

Content can be consumed from a feed or via the resource's endpoint directly. Use the [cortex-client](https://github.com/cbdr/cortex-client) gem to easily consume any content resource and use it in your application.

### Localizations

Localizations can be consumed via the client or via [i18n-backend-cortex](https://github.com/cortex-cms/i18n-backend-cortex), which allows easy localization for Rails applications.

### Webpages and Snippets

Webpages/Snippets can be consumed via the client or via the [content-snippets-view](https://github.com/cortex-cms/content-snippets-view) and [content-snippets](https://github.com/cortex-cms/content-snippets) libraries, which need to be configured and hosted in order to be consumed.

### Exceptions

If a consuming or companion application would like to produce Cortex-equivalent exceptions, use the [cortex-exceptions](https://github.com/cb-talent-development/cortex-exceptions) gem.

## Applications Using Cortex

* [Advice and Resources](https://github.com/cbdr/advice-and-resources) - Redesigned Workbuzz/Advice & Resources platform utilizing Cortex Posts and Rails. [Live Site](http://advice.careerbuilder.com/)
* [Employer](https://github.com/cbdr/employer) - Redesigned Employer Marketing platform utilizing Cortex Webpages/Snippets and Rails. [Live Site](http://hiring.careerbuilder.com/)
* [CB1 Lander Shell](https://github.com/cbdr/cb1-lander-shell) - Platform for hosting lander pages and experiments, utilizing Cortex Posts and Sinatra. [Live Site](http://corporate.careerbuilder.com/)
* [CareerBuilder.com](https://github.com/cbdr/consumer-main) - The main Consumer Web site for CB.com uses Cortex Posts for the [Privacy](http://www.careerbuilder.com/privacy) and [Terms of Service](http://www.careerbuilder.com/terms) pages.

## Troubleshooting
* For OS X / homebrew users: Run `which node` to ensure node is properly linked. The path shown should match homebrew's default installation path (run `which brew` to reveal this). If its not, then run `brew link node` and follow the instructions.

## Contributing

Anyone and everyone is encouraged to fork Cortex and submit pull requests, propose new features and create issues.

Review [CONTRIBUTING](CONTRIBUTING.md) for complete instructions before you submit a pull request or feature proposal.

## License

Cortex utilizes the Apache 2.0 License. See [LICENSE](LICENSE.md) for details.

## Copyright

Copyright (c) 2016 CareerBuilder, LLC.

[cb-ce-github]: https://github.com/cb-talent-development "Content Enablement on GitHub"
