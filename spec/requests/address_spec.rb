require 'spec_helper'

describe 'Addresses' do
  context 'editing' do
    include_context "user with address"

    it 'should be able to edit an address', :js => true do
      visit spree.root_path

      click_link I18n.t(:login)
      sign_in!(user)
      click_link I18n.t(:my_account)

      page.should have_content(I18n.t(:shipping_addresses))

      click_link I18n.t(:add_new_shipping_address)
      page.should have_content(I18n.t(:new_shipping_address))
    end
  end

end
