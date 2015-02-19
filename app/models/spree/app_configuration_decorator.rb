Spree::AppConfiguration.class_eval do
  preference :alternative_billing_phone, :boolean, default: false # Request extra phone for billing addr
end