source 'https://rubygems.org'

gem 'rails', '3.2.0'
gem 'grooveshark'

gem 'newrelic_rpm'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

gem 'json'

# To use Facebook authentication
gem 'omniauth-facebook'

# For RSpec testing framework
group :development do
  gem 'selenium-client', ">=1.2.16"
  gem 'rspec-rails', '2.6.1'
  gem 'simplecov'
end

# For RSpec testing in the test environment
group :test do
  gem 'rspec-rails', '2.6.1'
  gem 'simplecov'
  gem 'webrat', '0.7.1'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
