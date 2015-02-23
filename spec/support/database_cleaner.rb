require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    if RSpec.current_example.metadata[:js]
      DatabaseCleaner.strategy = :truncation, {
          :except => %w(spree_countries spree_zones spree_zone_members spree_states spree_roles)
      }
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
    reset_spree_preferences

    # not sure exactly what is happening here, but i think it takes an iteration for the country data to load
    Spree::Config[:default_country_id] = Spree::Country.find_by_iso3('USA').id if Spree::Country.count > 0
  end

  config.after do
    DatabaseCleaner.clean
  end
end