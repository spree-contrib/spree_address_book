Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_address_book'
  s.version     = '1.3.0'
  s.summary     = 'Adds address book for users to Spree'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Roman Smirnov'
  s.email             = 'roman@railsdog.com'
  s.homepage          = 'http://github.com/romul/spree_address_book'
  # s.rubyforge_project = 'actionmailer'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core', '~> 1.3.6.degica')
  s.add_dependency('spree_auth_devise')
  
  s.add_development_dependency('rspec-rails',  '2.12.0')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('capybara', '1.1')
  s.add_development_dependency('factory_girl_rails', '1.7.0')
  s.add_development_dependency('database_cleaner')
  s.add_development_dependency('ffaker')
end
