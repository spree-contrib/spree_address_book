module Spree
  module Admin
    class AddressesController < ResourceController
      def index
        @order = Spree::Order.find_by_number(params[:order_id])
        @user = @order.user
      end

      def new
        @order = Spree::Order.find_by_number(params[:order_id])
        country_id = Spree::Address.default.country.id
        @user = @order.user
        @address = @user.addresses.new(:country_id => country_id)
      end

      def create
        @order = Spree::Order.find_by_number(params[:order_id])
        @user = @order.user
        @address = @user.addresses.new(address_params)
        if @address.save
          @user.save_default_addresses(params[:address_billing],
                                       params[:address_shipping],
                                       @address)
          flash.now[:success] = Spree.t(:account_updated)
        end

        render :index
      end

      def edit
        @order = Spree::Order.find_by_number(params[:order_id])
        @user = @order.user
      end

      def update
        @address = Spree::Address.find(params[:id])
        @address.update_attributes(address_params)
        @address.user.save_default_addresses(
          params[:address_billing],
          params[:address_shipping],
          @address
        )
        flash[:success] = "Address updated successfully"
        redirect_to admin_order_addresses_url params[:order_id]
      end

      private

      def address_params
        params.require(:address)
          .permit(PermittedAttributes.address_attributes)
      end
    end
  end
end
