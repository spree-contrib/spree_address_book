Spree::CheckoutController.class_eval do
  after_filter :normalize_addresses, :only => :update
  before_filter :set_addresses, :only => :update
  
  protected
  
  def set_addresses
    return unless params[:order] && params[:state] == "address"

    if params[:order][:ship_address_id].to_i > 0
      params[:order].delete(:ship_address_attributes)
    else
      params[:order].delete(:ship_address_id)
    end
    
    if params[:order][:bill_address_id].to_i > 0
      params[:order].delete(:bill_address_attributes)
    else
      params[:order].delete(:bill_address_id)
    end
  end
  
  def normalize_addresses
    return unless params[:state] == "address" && @order.bill_address_id && @order.ship_address_id
    @order.bill_address.reload
    @order.ship_address.reload
    # ensure that there is no validation errors and addresses was saved
    return unless @order.bill_address && @order.ship_address
    
    if @order.bill_address_id != @order.ship_address_id && @order.bill_address.same_as?(@order.ship_address)
      @order.bill_address.destroy
      @order.update_attribute(:bill_address_id, @order.ship_address.id)
    else
      @order.bill_address.update_attribute(:user_id, current_user.try(:id))
    end
    @order.ship_address.update_attribute(:user_id, current_user.try(:id))
  end
end
