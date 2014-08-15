module Spree
  module Admin
    class AddressesController < ResourceController
      def index
        @order = Spree::Order.find_by_number(params[:order_id])
        country_id = Spree::Address.default.country.id
        @user = @order.user
        @user.build_bill_address(:country_id => country_id)
        @user.build_ship_address(:country_id => country_id)
      end

      def new
      end

      def create
        @order = Spree::Order.find_by_number(params[:order_id])
        @user = @order.user
        if @user.update_attributes(user_params)
          flash.now[:success] = Spree.t(:account_updated)
        end

        render :index
      end

      def update
      end

      private

      def user_params
        params.require(:user).permit(PermittedAttributes.user_attributes |
                                     [:spree_role_ids,
                                      ship_address_attributes: PermittedAttributes.address_attributes,
                                      bill_address_attributes: PermittedAttributes.address_attributes])
      end
    end
  end
end
