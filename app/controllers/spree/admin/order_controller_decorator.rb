Spree::Admin::OrdersController.class_eval do
  def addresses
    order = Spree::Order.find_by_number(params[:order_id])
    @user = order.user
  end
end
