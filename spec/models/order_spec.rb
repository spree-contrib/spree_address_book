require 'spec_helper'

describe Spree::Order do

  describe "Create order with the same bill & ship addresses" do
    it "should have equal ids when set ids" do
      address = Factory(:address)
      @order = Factory(:order, :bill_address_id => address.id, :ship_address_id => address.id)
      @order.bill_address_id.should == @order.ship_address_id
    end
  
    it "should have equal ids when option use_billing is active" do
      address = Factory(:address)
      @order  = Factory(:order, :use_billing => true,
                        :bill_address_id => address.id, 
                        :ship_address_id => nil)
      @order = @order.reload
      @order.bill_address_id.should == @order.ship_address_id
    end
  end
end
