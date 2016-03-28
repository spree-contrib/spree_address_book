ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.before(:each) do
    if RSpec.current_example.metadata[:js]
      DatabaseCleaner.strategy = :truncation, {
        except: [
          'spree_countries',
          'spree_zones',
          'spree_zone_members',
          'spree_roles'
        ]
      }
    else
      DatabaseCleaner.strategy = :transaction
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
    reset_spree_preferences

    # not sure exactly what is happening here, but i think it takes
    # an iteration for the country data to load
    if Spree::Country.count > 0
      Spree::Config[:default_country_id] = Spree::Country.find_by_iso3('USA').id
    end
    Spree::Config[:address_requires_state]
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
