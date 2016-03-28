require 'spec_helper'

describe 'Addresses', type: :feature, js: true do
  context 'editing' do
    include_context 'user with address'

    it 'should be able to edit an address' do
      visit spree.root_path

      sign_in!(user)
      click_link Spree.t(:my_account)

      expect(page).to have_content(I18n.t('address_book.shipping_addresses'))
      #sleep(1)
      click_link I18n.t('address_book.add_new_shipping_address')
      expect(page).to have_content(I18n.t('address_book.new_shipping_address'))
    end
  end

end
