Spree::Admin::UsersController.class_eval do
  def addresses
    if request.put?
      if @user.update_attributes(user_params)
        flash.now[:success] = Spree.t(:account_updated)
      end

      render :user_addresses
    end
    render :user_addresses
  end
end
