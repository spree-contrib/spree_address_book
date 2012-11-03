source "http://rubygems.org"
gemspec

group :test do
  gem 'sass'
  
  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'rb-fsevent'
    gem 'growl'
    gem 'guard-rspec'
  end
end

gem 'spree', '~> 1.1.3'
