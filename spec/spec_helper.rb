require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Configure Rails Environment
  ENV['RAILS_ENV'] = 'test'
  require File.expand_path('../dummy/config/environment.rb',  __FILE__)
  require 'rspec/rails'

  # gems
  require 'ffaker'
  require 'capybara/rspec'

  # Requires for spree_core
  require 'spree/core/url_helpers'
  require 'spree/core/testing_support/fixtures'
  require 'spree/core/testing_support/factories'
  require 'spree/core/testing_support/env'
  require 'spree/core/testing_support/controller_requests'

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation, { :only => %w[spree_users spree_addresses] }
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    # DRasband - added to avoid the "undefined method `authenticate' for
    # nil:NilClass" error
    config.include Devise::TestHelpers, :type => :controller
    config.include Spree::Core::UrlHelpers
    config.include Spree::Core::TestingSupport::ControllerRequests, :type => :controller
    config.include Warden::Test::Helpers
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

end
