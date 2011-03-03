class AddressesController < Spree::BaseController
  def destroy
    @address = Address.find(params[:id])
    if @address && @address.user == current_user
      if @address.can_be_deleted?
        @address.destroy
      else
        @address.update_attribute(:deleted_at, Time.now)
      end
    end
  end
end
