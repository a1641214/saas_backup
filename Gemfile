source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: %i[development test]
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# fast import of database objects
gem 'activerecord-import', github: 'zdennis/activerecord-import' # https://github.com/zdennis/activerecord-import

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Sprockets to transpile ES6
gem 'sprockets', '>= 3.0.0'
gem 'sprockets-es6'

group :development, :test do
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug'
end

group :development do
    # Access an IRB console on exception pages or by using <%= console %> in views
    gem 'web-console', '~> 2.0'

    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
end

#################################
####### APP SPECIFIC GEMS #######
#################################
group :production do
    gem 'pg' # for Heroku deployment
    gem 'rails_12factor'
end

group :development, :test do
    # Unit testing framework
    gem 'autotest'
    gem 'rspec-rails'

    # Rails Generators for Cucumber with special support for Capybara and DatabaseCleaner
    gem 'cucumber-rails', require: false
    gem 'cucumber-rails-training-wheels'

    # Clean up the database throughout the testing suite
    gem 'database_cleaner'

    # Acceptance test framework for web applications http://teamcapybara.github.io/capybara/
    gem 'capybara'

    # A helper for launching cross-platform applications in a fire and forget manner.
    gem 'launchy'
    # Testing suite generators
    gem 'ZenTest'

    # Rename the app
    gem 'rename'

    # Create models
    gem 'factory_girl_rails'

    # Fake data
    gem 'faker'
end

group :development, :test do
end

group :test do
    gem 'capybara-webkit'
    gem 'cucumber-rails', require: false
    gem 'cucumber-rails-training-wheels'
    gem 'simplecov', require: false
end

group :test do
    # Code coverage for Ruby
    gem 'simplecov', require: false
end

group :development do
    # Run Rspec when files have changed
    gem 'guard-rspec', require: false
    # Run Cucumber when files have changed
    gem 'guard-cucumber', require: false
    # This gem implements the rspec command for Spring
    gem 'spring-commands-rspec'
    # Automatically bundle when the Gemfile has been changed
    gem 'guard-bundler', require: false
    # Static analysis
    gem 'rubocop', require: false
    # hide asset log messages in development
    gem 'quiet_assets'
end

# Html templating markup language
gem 'haml-rails', '~> 0.9'

# Allows for safe use of and and
gem 'andand', '~> 1.3', '>= 1.3.3'

# Enables pretty console (ap)
gem 'awesome_print', '~> 1.6', '>= 1.6.1', require: 'ap'

# bootstrap material design
gem 'bootstrap-material-design'

# Bootstrap
gem 'twitter-bootstrap-rails'

gem 'selenium-webdriver', '~> 2.53', '>= 2.53.4'
