class Spree::AddressesController < Spree::BaseController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource
  respond_to :html

  def new
    @address = Spree::Address.default
    session["user_return_to"] = request.env['HTTP_REFERER']
  end

  def create
    @address.user = current_user
    if @address.update_attributes(params[:address])
      flash[:notice] = t(:successfully_saved, :resource => t(:address))
      redirect_back_or_default(spree.account_path)
    else
      respond_with(@address) { |format| format.html { render :edit } }
      return
    end
  end

  def edit
    session["user_return_to"] = request.env['HTTP_REFERER']
  end

  def update
    if @address.editable?
      if @address.update_attributes(params[:address])
        flash[:notice] = t(:successfully_updated, :resource => t(:address))
      else
        respond_with(@address) { |format| format.html { render :edit } }
        return
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
    if @address.can_be_deleted?
      @address.destroy
    else
      @address.update_attribute(:deleted_at, Time.now)
    end
    redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr?
  end
end
