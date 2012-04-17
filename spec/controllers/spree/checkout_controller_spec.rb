require 'spec_helper'

describe Spree::CheckoutController do
  #let(:user) { mock_model(Spree::User, :has_role? => true) }
  #let(:order) { mock_model(Spree::Order, :checkout_allowed? => true, :completed? => false, :update_attributes => true, :payment? => false, :insufficient_stock_lines => [], :line_items => [Factory(:line_item)], :coupon_code => nil, :bill_address_id => nil, :ship_address_id => nil, :user => user).as_null_object }
  
  before(:all) do
    @address = Factory(:address)
    @order = Factory(:order, :bill_address_id => nil, :ship_address_id => nil)
    @order.add_variant(Factory(:product).master, 1)
    @order.user = Factory(:user)
    @order.shipping_method = Factory(:shipping_method)
    @address.user = @order.user
    @order.save
    controller.stub :current_order => @order
    controller.stub :current_user => @order.user
  end
  
  describe "on address step" do
    it "set equal address ids" do
      put_address_to_order(:bill_address_id => @address.id, :ship_address_id => @address.id)
      @order = Spree::Order.last
      @order.bill_address_id.should_not == nil
      @order.ship_address_id.should_not == nil
      @order.bill_address_id.should == @address.id
      @order.bill_address_id.should == @order.ship_address_id
    end
    
    it "set bill_address_id and use_billing" do
      put_address_to_order(:bill_address_id => @address.id, :use_billing => true)
      @order = @order.reload
      @order.bill_address_id.should_not == nil
      @order.ship_address_id.should_not == nil
      @order.bill_address_id.should == @address.id
      @order.bill_address_id.should == @order.ship_address_id
    end
    
    it "set address attributes" do
      put_address_to_order(:bill_address_attributes => @address.clone.attributes, :ship_address_attributes => @address.clone.attributes)
      @order = Spree::Order.find(@order.id)
      @order.bill_address_id.should_not == nil
      @order.ship_address_id.should_not == nil
      @order.bill_address_id.should == @order.ship_address_id
    end
  end
  
  private
  
  def put_address_to_order(params)
    put :update, {:use_route => :spree, :state => "address", :order => params}
  end
  
  
end
