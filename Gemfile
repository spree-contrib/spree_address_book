source "http://rubygems.org"
gemspec

group :test do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'

  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'rb-fsevent'
    gem 'growl'
    gem 'guard-rspec'
  end
end

gem 'spree_auth_devise', :git => 'git://github.com/spree/spree_auth_devise'
gem 'spree', '~> 1.2'
