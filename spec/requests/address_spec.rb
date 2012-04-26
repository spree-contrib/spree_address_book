require 'spec_helper'

describe 'Addresses' do
  context 'editing' do
    let(:address) { FactoryGirl.create(:address) }
    let(:user) { FactoryGirl.create(:user) }
    before {
      address.user = user
      address.save
    }

    before(:each) {
      login_as user, :scope => :user
    }

    it 'should be able to edit an address' do
      visit spree.root_path

      click_link "My Account"
      page.should have_content("Shipping Addresses")

      click_link "Add new shipping address"
      page.should have_content("New Shipping Address")
    end
  end

end
