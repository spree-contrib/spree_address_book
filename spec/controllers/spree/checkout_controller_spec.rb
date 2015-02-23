RSpec.describe Spree::CheckoutController, type: :controller do
  
  before(:each) do
    user = FactoryGirl.create(:user)
    @address = FactoryGirl.create(:address, :user => user)

    @order = FactoryGirl.create(:order_with_line_items, :bill_address_id => nil, :ship_address_id => nil)
    # @order.contents.add(FactoryGirl.create(:product).master, 1)
    @order.user = user
    # @order.shipping_method = FactoryGirl.create(:shipment)
    @address.user = @order.user
    @order.save
    
    allow(controller).to receive(:current_order) { @order }
    allow(controller).to receive(:spree_current_user) { @order.user }
  end
  
  context "on address step" do
    it "set equal address ids" do
      put_address_to_order('bill_address_id' => @address.id, 'ship_address_id' => @address.id)
      expect(@order.bill_address).to be_present
      expect(@order.ship_address).to be_present
      expect(@order.bill_address_id).to eq(@address.id)
      expect(@order.bill_address_id).to eq(@order.ship_address_id)
    end
    
    it "set bill_address_id and use_billing" do
      put_address_to_order(:bill_address_id => @address.id, :use_billing => true)
      expect(@order.bill_address).to be_present
      expect(@order.ship_address).to be_present
      expect(@order.bill_address_id).to eq(@address.id)
      expect(@order.bill_address_id).to eq(@order.ship_address_id)
    end
    
    it "set address attributes" do
      # clone the unassigned address for easy creation of valid data
      # remove blacklisted attributes to avoid mass-assignment error
      cloned_attributes = @address.clone.attributes.select { |k,v| !['id', 'created_at', 'deleted_at', 'updated_at'].include? k }
      
      put_address_to_order(:bill_address_attributes => cloned_attributes, :ship_address_attributes => cloned_attributes)
      expect(@order.bill_address_id).not_to be_nil
      expect(@order.ship_address_id).not_to be_nil
      expect(@order.bill_address_id).to eq(@order.ship_address_id)
    end
  end
  
  private
  
  def put_address_to_order(params)
    spree_post :update, {
      :state => 'address',
      :order => params
    }
  end
  
  
end
