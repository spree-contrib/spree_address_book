module Spree
  module Admin
    class AddressesController < ResourceController
      def index
        @order = Spree::Order.find_by_number(params[:order_id])
        @user = @order.user

        @default_user_addresses_hash = {
          I18n.t(:billing_address, scope: :address_book) => @user.bill_address,
          I18n.t(:shipping_address, scope: :address_book) => @user.ship_address
        }

        previous_order = Spree::Order.where(user_id: @user.id).order(:created_at).last

        if previous_order
          @previous_order_addresses_hash = {
            I18n.t(:billing_address, scope: :address_book) => previous_order.bill_address,
            I18n.t(:shipping_address, scope: :address_book) => previous_order.ship_address
          }
        end
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
          @order.set_current
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

        @order = Spree::Order.find_by_number(params[:order_id])
        @order.save_current_order_addresses(
          params[:address_current_order_bill],
          params[:address_current_order_ship],
          @address
        )

        flash[:success] = "Address updated successfully"
        redirect_to admin_order_addresses_url @order
      end

      private

      def address_params
        params.require(:address)
          .permit(PermittedAttributes.address_attributes)
      end
    end
  end
end
