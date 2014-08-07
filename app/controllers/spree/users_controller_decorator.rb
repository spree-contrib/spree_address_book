Spree::Admin::UsersController.class_eval do
  def create
    if params[:user]
      roles = params[:user].delete("spree_role_ids")
    end

    @user = Spree.user_class.new(user_params)
    if @user.save
      @user.bill_address.update(user_id: @user.id)

      if roles
        @user.spree_roles = roles.reject(&:blank?).collect{|r| Spree::Role.find(r)}
      end

      flash.now[:success] = Spree.t(:created_successfully)
      render :edit
    else
      render :new
    end
  end
end
