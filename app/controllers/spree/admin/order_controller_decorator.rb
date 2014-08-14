Spree::Admin::OrdersController.class_eval do
  def addresses
    order = Spree::Order.find_by_number(params[:id])
    @user = order.user
    @user.build_ship_address
    @user.build_bill_address
  end
end
