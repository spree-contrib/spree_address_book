require 'spec_helper'

describe Spree::Address do
  let(:address) { FactoryGirl.create(:address) }
  let(:address2) { FactoryGirl.create(:address) }
  let(:order) { FactoryGirl.create(:completed_order_with_totals) }
  let(:user) { FactoryGirl.create(:user) }

  before { order.update_attribute(:bill_address, address2) }

  it 'has required attributes' do
    Spree::Address.required_fields.should eq([:firstname, :lastname, :address1, :city, :country, :zipcode, :phone])
  end

  it 'is editable' do
    address.should be_editable
  end

  it 'can be deleted' do
    address.should be_can_be_deleted
  end

  it "isn't editable when there is an associated order" do
    address2.should_not be_editable
  end

  it "can't be deleted when there is an associated order" do
    address2.should_not be_can_be_deleted
  end

  it 'is displayed as string' do
    a = address
    address.to_s.should eq("#{a.firstname} #{a.lastname}<br/>#{a.company}<br/>#{a.address1}<br/>#{a.address2}<br/>#{a.city}, #{a.state ? a.state.abbr : a.state_name} #{a.zipcode}<br/>#{a.country}".html_safe)
  end

  it 'is destroyed without saving used' do
    address.destroy
    Spree::Address.where(["id = (?)", address.id]).should be_empty
  end

  it 'is destroyed deleted timestamp' do
    address2.destroy
    Spree::Address.where(["id = (?)", address2.id]).should_not be_empty
  end
end
