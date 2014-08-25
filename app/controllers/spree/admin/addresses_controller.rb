module Spree
  module Admin
    class AddressesController < ResourceController
      def index
        @order = Spree::Order.find_by_number(params[:order_id])
        @user = @order.user

        @default_user_addresses_hash = {}

        if @user
          if @user.bill_address
            @default_user_addresses_hash[I18n.t(:billing_address, scope: :address_book)] = @user.bill_address
          end

          if @user.ship_address
            @default_user_addresses_hash[I18n.t(:shipping_address, scope: :address_book)] = @user.ship_address
          end

          @current_order_addresses_hash = {}
          if @order.bill_address
            @current_order_addresses_hash[I18n.t(:billing_address, scope: :address_book)] = @order.bill_address
          end

          if @order.ship_address
            @current_order_addresses_hash[I18n.t(:shipping_address, scope: :address_book)] = @order.ship_address
          end

          previous_order = Spree::Order.where(user_id: @user.id).order(:created_at).last

          if previous_order != @order
            @previous_order_addresses_hash= {}
            if previous_order.bill_address
              @previous_order_addresses_hash[I18n.t(:billing_address, scope: :address_book)] = previous_order.bill_address
            end

            if previous_order.ship_address
              @previous_order_addresses_hash[I18n.t(:shipping_address, scope: :address_book)] = previous_order.ship_address
            end
          end
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
          @user.save_default_addresses(
            params[:address_default_bill],
            params[:address_default_ship],
            @address
          )

          @order = Spree::Order.find_by_number(params[:order_id])

          @order.save_current_order_addresses(
            params[:address_current_order_bill],
            params[:address_current_order_ship],
            @address
          )

          flash.now[:success] = Spree.t(:account_updated)
        end

        redirect_to admin_order_addresses_url @order
      end

      def edit
        @order = Spree::Order.find_by_number(params[:order_id])
        @user = @order.user
      end

      def update
        @address = Spree::Address.find(params[:id])

        if @address.update_attributes(address_params)
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
        end

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
