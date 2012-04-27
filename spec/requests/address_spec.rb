require 'spec_helper'

describe 'Addresses' do
  context 'editing' do
    include_context "user with address"

    it 'should be able to edit an address', :js => true do
      visit spree.root_path

      click_link I18n.t(:login)
      sign_in!(user);
      click_link I18n.t(:my_account)

      page.should have_content("Shipping Addresses")

      click_link "Add new shipping address"
      page.should have_content("New Shipping Address")
    end
  end

end
