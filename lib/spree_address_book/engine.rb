module Spree
  module AddressBook
    class Engine < Rails::Engine
      require 'spree/core'
      isolate_namespace Spree
      engine_name 'spree_address_book'

      initializer "spree.address_book.environment", :before => :load_config_initializers do |app|
        Spree::AddressBook::Config = Spree::AddressBookConfiguration.new
      end

      config.autoload_paths += %W(#{config.root}/lib)

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
        Spree::Ability.register_ability(Spree::AddressAbility)
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end
