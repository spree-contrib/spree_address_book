Spree::CheckoutController.class_eval do
  helper Spree::AddressesHelper

  after_filter :normalize_addresses, :only => :update
  before_filter :set_addresses, :only => :update

  protected

  def set_addresses
    return unless params[:order] && params[:state] == "address"

    if params[:order][:ship_address_id].to_i > 0
      params[:order].delete(:ship_address_attributes)

      Spree::Address.find(params[:order][:ship_address_id]).user_id != spree_current_user.id && raise("Frontend address forging")
    else
      params[:order].delete(:ship_address_id)
    end

    if params[:order][:bill_address_id].to_i > 0
      params[:order].delete(:bill_address_attributes)

      Spree::Address.find(params[:order][:bill_address_id]).user_id != spree_current_user.id && raise("Frontend address forging")
    else
      params[:order].delete(:bill_address_id)
    end

  end

  def normalize_addresses
    return unless params[:state] == "address" && @order.bill_address_id && @order.ship_address_id

    # ensure that there is no validation errors and addresses were saved
    return unless @order.bill_address and @order.ship_address

    bill_address = @order.bill_address
    ship_address = @order.ship_address
    if @order.bill_address_id != @order.ship_address_id && bill_address.same_as?(ship_address)
      @order.update_column(:bill_address_id, ship_address.id)
      bill_address.destroy
    else
      bill_address.update_attribute(:user_id, spree_current_user.try(:id))
    end

    ship_address.update_attribute(:user_id, spree_current_user.try(:id))
  end
end
