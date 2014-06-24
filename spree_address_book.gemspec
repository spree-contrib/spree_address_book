Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_address_book'
  s.version     = '2.2.2'
  s.summary     = "Adds an Address Book for Spree Users"
  s.description = "A gem for that adds a managable Address Book of Shipping and Billing Addresses for each Spree User"
  s.required_ruby_version = '>= 1.9.3'
  s.date        = '2014-06-19'

  s.authors            = ["Roman Smirnov"]
  s.email             = 'roman@railsdog.com'
  s.homepage          = 'http://github.com/romul/spree_address_book'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '~> 2.2.2'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_auth_devise'
  s.add_dependency 'spree_frontend', spree_version

  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'rspec-rails', '~> 2.14'
  s.add_development_dependency 'shoulda-matchers', '~> 2.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'factory_girl', '~> 4.4.0'
  s.add_development_dependency 'database_cleaner', '~> 1.2.0'
  s.add_development_dependency 'sqlite3', '~> 1.3.8'
  s.add_development_dependency 'capybara', '~> 2.2.1'
  s.add_development_dependency 'poltergeist'
end
