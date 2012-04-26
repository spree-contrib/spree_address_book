Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_address_book'
  s.version     = '1.1.0'
  s.summary     = 'Adds address book for users to Spree'
  s.description = 'Adds address book for users so that they can save shipping addresses to their accounts for later use.'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Dan Rasband'
  s.email             = 'dan@agencyfusion.com'
  s.homepage          = 'http://github.com/danrasband/spree_address_book'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core', '>= 1.1.0.rc2')
  s.add_dependency('spree_auth', '>= 1.1.0.rc2')
  s.add_dependency('spree_api', '>= 1.1.0.rc2')

  s.add_development_dependency 'capybara', '1.0.1'
  #s.add_development_dependency 'factory_girl', '~> 2.6.4'
  #s.add_development_dependency 'ffaker'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'sqlite3'
end
