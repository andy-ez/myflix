source 'https://rubygems.org'
ruby '2.2.2'

gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails'
gem 'rails', '4.1.9'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'carrierwave-aws'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'figaro'
gem 'sidekiq'
gem 'stripe'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'fabrication'
  gem 'faker'
  gem 'selenium-webdriver'
  gem "capybara-webkit"
end

group :test do
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '2.9.3'
  gem 'webmock'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end

