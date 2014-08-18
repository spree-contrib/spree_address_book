Spree::Admin::OrdersController.class_eval do
  def new
    @order = Spree::Order.create(order_params)
    user = @order.user
    if user
      @order.update_attributes(bill_address_id: user.bill_address.id)
      @order.update_attributes(ship_address_id: user.ship_address.id)
    end
    redirect_to edit_admin_order_url(@order)
  end

  def addresses
    @order = Spree::Order.find_by_number(params[:id])
    country_id = Spree::Address.default.country.id
    @user = @order.user
    @user.build_bill_address(:country_id => country_id)
    @user.build_ship_address(:country_id => country_id)
    render 'spree/admin/addresses/addresses'
  end

  private

  def order_params
    params[:created_by_id] = try_spree_current_user.try(:id)
    params.permit(:created_by_id, :user_id)
  end
end
