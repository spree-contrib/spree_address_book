require 'spec_helper'

describe 'Addresses' do
  context 'editing' do
    include_context "user with address"

    it 'should be able to edit an address', :js => true do
      visit spree.root_path

      click_link Spree.t(:login)
      sign_in!(user)
      click_link Spree.t(:my_account)

      page.should have_content(I18n.t('address_book.shipping_addresses'))
      #sleep(1)
      click_link I18n.t('address_book.add_new_shipping_address')
      page.should have_content(I18n.t('address_book.new_shipping_address'))
    end
  end

end
