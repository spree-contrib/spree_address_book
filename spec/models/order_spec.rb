require 'spec_helper'

describe Spree::Order do
  let(:order) { create(:order) }
  let(:address) { create(:address, :user => order.user) }

  describe 'mass attribute assignment for bill_address_id, ship_address_id' do
    it 'should be able to mass assign bill_address_id' do
      params = { :bill_address_id => address.id }
      order.update_attributes(params)
      expect(order.bill_address_id).to eq address.id
    end

    it 'should be able to mass assign ship_address_id' do
      params = { :ship_address_id => address.id }
      order.update_attributes(params)
      expect(order.ship_address_id).to eq address.id
    end
  end

  describe 'Create order with the same bill & ship addresses' do
    it 'should have equal ids when set ids' do
      address = create(:address)
      @order = create(:order, :bill_address_id => address.id, :ship_address_id => address.id)
      expect(@bill_address_id).to eq @order.ship_address_id
    end

    it 'should have equal ids when option use_billing is active' do
      address = create(:address)
      @order  = create(:order, :use_billing => true,
                        :bill_address_id => address.id,
                        :ship_address_id => nil)
      @order = @order.reload
      expect(@order.bill_address_id).to eq @order.ship_address_id
    end
  end
end
