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

  it 'is destroyed without saving used' do
    address.destroy
    expect(Spree::Address.where(['id = (?)', address.id])).to be_empty
  end

  it 'is destroyed deleted timestamp' do
    address2.destroy
    expect(Spree::Address.where(['id = (?)', address2.id])).to_not be_empty
  end

  describe '#to_s' do
    it 'is displayed as string' do
      a = address
      expect(address.to_s).to eq("#{a.full_name}<br/>#{a.company}<br/>#{a.address1}<br/>#{a.address2}<br/>#{a.city}, #{a.state_text} #{a.zipcode}<br/>#{a.country}")
      address.company = nil
      expect(address.to_s).to eq("#{a.full_name}<br/>#{a.address1}<br/>#{a.address2}<br/>#{a.city}, #{a.state_text} #{a.zipcode}<br/>#{a.country}")
    end

    context 'address contains HTML' do
      it 'properly escapes HTML' do
        dangerous_string = '<script>alert("BOOM!")</script>'
        address = create(:address, first_name: dangerous_string)

        expect(address.to_s).not_to include(dangerous_string)
      end
    end
  end
end
