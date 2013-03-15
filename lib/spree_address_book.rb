require 'spree_core'

module Spree
  module AddressBook
    class Engine < Rails::Engine
      engine_name 'spree_address_book'
      
      initializer "spree.address_book.environment", :before => :load_config_initializers do |app|
        Spree::AddressBook::Config = Spree::AddressBookConfiguration.new
      end
      
      config.autoload_paths += %W(#{config.root}/lib)

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../app/**/spree/*_decorator*.rb")) do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
        Spree::Ability.register_ability(Spree::AddressAbility)
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end
