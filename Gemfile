source 'http://rubygems.org'

group :development, :test do
  gem 'spree', '~> 1.0.0'
  gem 'sqlite3'
end

group :test do
  gem 'rspec-rails', '~> 2.8'
  gem 'capybara', '~> 1.1'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 1.4'
  gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'guard-rspec'
  
  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'rb-fsevent'
    gem 'growl'
  end
end

gemspec
