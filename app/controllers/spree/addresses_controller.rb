class Spree::AddressesController < Spree::BaseController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource
  
  # removed by manton branch
  # def new
  #   @address = Spree::Address.default
  #   session["user_return_to"] = request.env['HTTP_REFERER']
  # end
  # 
  # def create
  #   @address.user = current_user
  #   if @address.update_attributes(params[:address])
  #     flash[:notice] = t(:successfully_saved, :resource => t(:address))
  #   else
  #     flash[:error] = t(:unsuccessfully_saved, :resource => t(:address))
  #   end
  #   redirect_back_or_default(account_path)
  # end
  # 
  # def edit
  #   session["user_return_to"] = request.env['HTTP_REFERER']
  # end

  def update
    if @address.editable?
      if @address.update_attributes(params[:address])
        flash[:notice] = t(:successfully_updated, :resource => t(:address))
      else
        flash[:error] = t(:unsuccessfully_updated, :resource => t(:address))
      end
    else
      new_address = @address.clone
      new_address.attributes = params[:address]
      @address.update_attribute(:deleted_at, Time.now)
      if new_address.save
        flash[:notice] = t(:successfully_updated, :resource =>t(:address))
      end
    end
    redirect_back_or_default(account_path)
  end

  def destroy
    @address.destroy

    flash[:notice] = I18n.t(:successfully_removed, :resource => I18n.t(:address))
    redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr?
  end
end
