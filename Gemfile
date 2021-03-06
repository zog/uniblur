source 'https://rubygems.org'
ruby '2.1.6'
gem 'rails', '4.1.5'
gem 'spring',        group: :development
gem 'unicorn'
gem 'unicorn-rails'
gem 'settingslogic'
gem 'sendgrid'
gem 'sdoc', '~> 0.4.0',          group: :doc

# Auth
gem 'devise'
gem 'devise-i18n'
gem 'pundit'
gem 'createsend'

# Database
gem 'pg'

# Views
gem 'haml-rails'
gem 'simple_form'
gem 'nested_form'
gem 'enum_help'
gem 'redcarpet'

# Assets
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'bootstrap-sass'
gem 'compass-rails'

# Models
gem 'annotate'
gem 'kaminari'
gem 'verbs'
gem 'uuidtools'

# Uploaders
gem 'rmagick', require: false
gem 'carrierwave'
gem 'carrierwave-meta'
gem 'fog'
gem 'aws-sdk'
gem 'faker'

# Delayed Job
gem 'delayed_job'
gem 'delayed_job_active_record'

gem 'tprint-debug', git: 'https://github.com/3print/tprint-debug'
gem 'exception_notification'
gem 'slack-notifier'

group :development do
  gem 'better_errors'
  # gem 'binding_of_caller', platforms: [:mri_19, :mri_20, :mri_21, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-livereload', '1.0.3'
  # gem 'listen', '1.3.0'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'rsense'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'selenium-webdriver'
end
