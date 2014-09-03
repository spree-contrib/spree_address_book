module Spree
  module Admin
    class AddressesController < ResourceController
      def index
        @order = Spree::Order.find_by(number: params[:order_id])
        @user =
          if @order
            @order.user
          else
            Spree::User.find(params[:user_id])
          end

        @default_user_addresses_hash = {}

        if @user
          if @user.bill_address
            @default_user_addresses_hash[I18n.t(:billing_address, scope: :address_book)] = @user.bill_address
          end

          if @user.ship_address
            @default_user_addresses_hash[I18n.t(:shipping_address, scope: :address_book)] = @user.ship_address
          end
        end

        if @order
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

        render 'spree/admin/users/user_addresses' unless @order
      end

      def new
        @user = Spree::User.find(params[:user_id])
        @order = Spree::Order.find_by_number(params[:order])
        country_id = Spree::Address.default.country.id
        @address = @user.addresses.new(:country_id => country_id)
      end

      def create
        @order = Spree::Order.find_by_number(params[:order])
        @user = Spree::User.find(params[:user_id])
        @address = @user.addresses.new(address_params)

        if @address.save
          @user.save_default_addresses(
            params[:address_default_bill],
            params[:address_default_ship],
            @address
          )

          if @order
            @order.save_current_order_addresses(
              params[:address_current_order_bill],
              params[:address_current_order_ship],
              @address
            )
          end

          flash.now[:success] = Spree.t(:account_updated)
        end

        path =
          if @order
            admin_order_addresses_url @order
          else
            admin_user_addresses_url @user
          end

        redirect_to path
      end

      def edit
        @address = Spree::Address.find(params[:id])
        @order = Spree::Order.find_by(number: params[:order])
        @user = @address.user
      end

      def update
        @address = Spree::Address.find(params[:id])
        @user = @address.user

        if @address.update_attributes(address_params)
          @address.user.save_default_addresses(
            params[:address_default_bill],
            params[:address_default_ship],
            @address
          )

          @order = Spree::Order.find_by_number(params[:order])

          if @order
            @order.save_current_order_addresses(
              params[:address_current_order_bill],
              params[:address_current_order_ship],
              @address
            )
          end

          flash[:success] = "Address updated successfully"
        end

        path =
          if @order
            admin_order_addresses_url @order
          else
            admin_user_addresses_url @user
          end
        redirect_to path
      end

      private

      def address_params
        params.require(:address)
          .permit(PermittedAttributes.address_attributes)
      end
    end
  end
end
