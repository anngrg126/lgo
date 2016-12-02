source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
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

gem 'zurb-foundation', '~> 4.3', '>= 4.3.2'

gem 'devise', '~> 4.1', '>= 4.1.1'

gem 'foundation-rails'

gem 'foundation-icons-sass-rails'

gem 'slim-rails'

gem 'font-awesome-rails'

#gem for random text generation
gem 'faker', '~> 1.6', '>= 1.6.6'

#gem for facebook login
gem 'omniauth-facebook'

#gem for multi-step forms
gem 'wicked'

#gems for uploading images to Amazon S3
gem 'paperclip'
gem 'aws-sdk', '~> 2.3'

#gem to submit file upload via AJAX
gem 'remotipart', '~> 1.2'

#gem for rich text editing
gem 'trix'

#gem for sanitizing html input
gem 'rails-html-sanitizer'

#gem for handling nested model attributes in one form
gem 'cocoon'

#gem for generating friendly urls
gem 'friendly_id', '~> 5.1.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+

#gem for handling cron jobs
gem 'whenever', :require => false

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rails-controller-testing'
end

group :development do
  gem 'pg'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
end