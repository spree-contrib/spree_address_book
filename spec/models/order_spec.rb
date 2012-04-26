require 'spec_helper'

describe Spree::Order do
  let(:order) { FactoryGirl.create(:order) }
  let(:address) { FactoryGirl.create(:address) }

  describe 'mass attribute assignment for bill_address_id, ship_address_id' do
    it 'should be able to mass assign bill_address_id' do
      params = { :bill_address_id => address.id }
      order.update_attributes(params)
      order.bill_address_id.should eq(address.id)
    end

    it 'should be able to mass assign ship_address_id' do
      params = { :ship_address_id => address.id }
      order.update_attributes(params)
      order.ship_address_id.should eq(address.id)
    end
  end

end
