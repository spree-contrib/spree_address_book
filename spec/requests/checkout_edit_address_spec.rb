require 'spec_helper'

describe "User editing saved address during checkout", :js => true do
  include_context "store products"
  include_context "checkout with product"
  include_context "user with address"

  before(:each) { click_link "Checkout"; sign_in!(user) }

  it "can update billing address" do
    within("#billing #billing_address_#{address.id}") do
      click_link "Edit"
    end
    current_path.should == spree.edit_address_path(address)
    new_street = Faker::Address.street_address
    fill_in I18n.t('activerecord.attributes.spree/address.address1'), :with => new_street
    click_button "Update"
    current_path.should == spree.checkout_state_path('address')
    within("h1") { page.should have_content("Checkout") }
    within("#billing") do
      page.should have_content(new_street)
    end
  end

  it "can update shipping address", :js => true do
    within("#shipping #shipping_address_#{address.id}") do
      click_link "Edit"
    end
    current_path.should == spree.edit_address_path(address)
    new_street = Faker::Address.street_address
    fill_in I18n.t('activerecord.attributes.spree/address.address1'), :with => new_street
    click_button "Update"
    current_path.should == spree.checkout_state_path('address')
    within("h1") { page.should have_content("Checkout") }
    within("#shipping") do
      page.should have_content(new_street)
    end
  end
end
