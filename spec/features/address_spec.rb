require 'spec_helper'

describe 'Addresses' do
  context 'editing' do
    include_context "support helper"
    include_context "user with address"

    it 'should be able to edit an address', :js => true do
      visit spree.root_path

      click_link Spree.t(:login)
      sign_in!(user)
      click_link Spree.t(:my_account)

      expect(page).to have_content(I18n.t(:shipping_addresses, :scope => :address_book))
      click_link I18n.t(:add_new_shipping_address, :scope => :address_book)
      expect(page).to have_content(I18n.t(:new_shipping_address, :scope => :address_book))
    end
  end

end
