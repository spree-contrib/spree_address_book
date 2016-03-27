require 'spec_helper'

describe Spree::Address do
  let(:address) { create(:address) }
  let(:address2) { create(:address) }
  let(:order) { create(:completed_order_with_totals) }
  let(:user) { create(:user) }

  before { order.update_attribute(:bill_address, address2) }

  it 'has required attributes' do
    expect(Spree::Address.required_fields).to eq([:firstname, :lastname, :address1, :city, :country, :zipcode, :phone])
  end

  it 'is editable' do
    expect(address).to be_editable
  end

  it 'can be deleted' do
    expect(address).to be_can_be_deleted
  end

  it "isn't editable when there is an associated order" do
    expect(address2).to_not be_editable
  end

  it "can't be deleted when there is an associated order" do
    expect(address2).to_not be_can_be_deleted
  end

  it 'is displayed as string' do
    a = address
    expect(address.to_s).to eq "#{a.firstname} #{a.lastname}<br/>#{a.company}<br/>#{a.address1}<br/>#{a.address2}<br/>#{a.city}, #{a.state ? a.state.abbr : a.state_name} #{a.zipcode}<br/>#{a.country}".html_safe
  end

  it 'is destroyed without saving used' do
    address.destroy
    expect(Spree::Address.where(['id = (?)', address.id])).to be_empty
  end

  it 'is destroyed deleted timestamp' do
    address2.destroy
    expect(Spree::Address.where(['id = (?)', address2.id])).to_not be_empty
  end
end
