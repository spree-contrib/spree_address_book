require 'spec_helper'

describe Spree::CheckoutController do
  before(:each) do
    user = FactoryGirl.create(:user)
    @address = FactoryGirl.create(:address, :user => user)
    
    @order = FactoryGirl.create(:order, :bill_address_id => nil, :ship_address_id => nil)
    @order.contents.add(FactoryGirl.create(:product, :sku => "Demo-SKU").master, 1)
    @order.user = user
    @address.user = @order.user
    @order.save
    allow(controller).to receive(:spree_current_user).and_return(@order.user)
  end
  
  describe "on address step" do
    it "set equal address ids" do
      put_address_to_order('bill_address_id' => @address.id, 'ship_address_id' => @address.id)
      @order.bill_address.should be_present
      @order.ship_address.should be_present
      @order.bill_address_id.should == @address.id
      @order.bill_address_id.should == @order.ship_address_id
    end
    
    it "set bill_address_id and use_billing" do
      put_address_to_order(:bill_address_id => @address.id, :use_billing => true)
      @order.bill_address.should be_present
      @order.ship_address.should be_present
      @order.bill_address_id.should == @address.id
      @order.bill_address_id.should == @order.ship_address_id
    end
    
    it "set address attributes" do
      # clone the unassigned address for easy creation of valid data
      # remove blacklisted attributes to avoid mass-assignment error
      cloned_attributes = @address.clone.attributes.select { |k,v| !['id', 'created_at', 'deleted_at', 'updated_at'].include? k }
      
      put_address_to_order(:bill_address_attributes => cloned_attributes, :ship_address_attributes => cloned_attributes)
      @order.bill_address_id.should_not == nil
      @order.ship_address_id.should_not == nil
      @order.bill_address_id.should == @order.ship_address_id
    end
  end
  
  private
  
  def put_address_to_order(params)
    spree_put :update, {:state => "address", :order => params}
    @order.reload
  end
  
  
end
