ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'minitest/autorun'
require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

# Requires factories defined in spree_core
require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/preferences'
require 'spree/testing_support/url_helpers'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::Preferences
  config.include Spree::TestingSupport::ControllerRequests
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation, {
        :except => [
          'spree_countries',
          'spree_zones',
          'spree_zone_members',
          'spree_states',
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

    Capybara.ignore_hidden_elements = false # find all elements (hidden or visible)
    # not sure exactly what is happening here, but i think it takes an iteration for the country data to load
    Spree::Config[:default_country_id] = Spree::Country.find_by_iso3('USA').id if Spree::Country.count > 0
    Spree::Config[:address_requires_state]
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
