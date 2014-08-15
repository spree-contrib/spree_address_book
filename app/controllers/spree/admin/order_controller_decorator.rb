Spree::Admin::OrdersController.class_eval do
  def addresses
    order = Spree::Order.find_by_number(params[:id])
    country_id = Spree::Address.default.country.id
    @user = order.user
    @user.build_bill_address(:country_id => country_id)
    @user.build_ship_address(:country_id => country_id)
  end
end
