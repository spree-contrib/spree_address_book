CheckoutController.class_eval do
  after_filter :normalize_addresses, :only => :update
  before_filter :set_addresses, :only => :update
  
  protected
  
  def set_addresses
    return unless params[:order]
    
    ship_address_id = params[:order].delete(:ship_address_id)
    if ship_address_id.to_i > 0
      params[:order].delete(:ship_address_attributes)
      ship_address = Address.find(ship_address_id)
      if ship_address && ship_address.user_id == current_user.try(:id)
        @order.ship_address_id = ship_address.id
      end
    else
      ship_address_id = params[:order][:ship_address_attributes][:id]
      if ship_address_id
        ship_address = Address.find(ship_address_id)
        if ship_address && !ship_address.editable?
          params[:order][:ship_address_attributes].delete(:id)
        end
      end
    end
    
    bill_address_id = params[:order].delete(:bill_address_id)
    if bill_address_id.to_i > 0
      params[:order].delete(:bill_address_attributes)
      bill_address = Address.find(bill_address_id)
      if bill_address && bill_address.user_id == current_user.try(:id)
        @order.bill_address_id = bill_address.id
      end
    else
      bill_address_id = params[:order][:bill_address_attributes][:id]
      if bill_address_id
        bill_address = Address.find(bill_address_id)
        if bill_address && !bill_address.editable?
          params[:order][:bill_address_attributes].delete(:id)
        end
      end
    end
  end
  
  def normalize_addresses
    return unless @order.bill_address_id
    if @order.bill_address_id != @order.ship_address_id && @order.bill_address.same_as?(@order.ship_address) 
      @order.bill_address.destroy
      @order.update_attribute(:bill_address_id, @order.ship_address_id)
    else
      @order.bill_address.update_attribute(:user_id, current_user.try(:id))
    end
    @order.ship_address.update_attribute(:user_id, current_user.try(:id))
  end
end
