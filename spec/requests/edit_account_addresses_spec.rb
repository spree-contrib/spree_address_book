require 'spec_helper'

describe "User editing addresses for his account" do
  include_context "user with address"

  before(:each) do
    visit spree.root_path
    click_link "Login"
    sign_in!(user)
    click_link "My Account"
  end

  it "should see list of addresses saved for account" do
    page.should have_content("Addresses")
    page.should have_selector("#user_addresses > tbody > tr", :count => user.addresses.count)
  end

  it "should be able to add address" do
    
  end

  it "should be able to edit address", :js => true do
    page.evaluate_script('window.confirm = function() { return true; }')
    within("#user_addresses > tbody > tr:first") do
      click_link I18n.t(:edit)
    end
    current_path.should == spree.edit_address_path(address)

    new_street = Faker::Address.street_address
    fill_in I18n.t('activerecord.attributes.spree/address.address1'), :with => new_street
    click_button "Update"
    current_path.should == spree.account_path
    page.should have_content(I18n.t('successfully_updated'))

    within("#user_addresses > tbody > tr:first") do
      page.should have_content(new_street)
    end
  end

  it "should be able to remove address", :js => true do
    # bypass confirm dialog
    page.evaluate_script('window.confirm = function() { return true; }')
    within("#user_addresses > tbody > tr:first") do
      click_link I18n.t(:remove)
    end
    current_path.should == spree.account_path

    # flash message
    page.should have_content("removed")

    # header still exists for the area - even if it is blank
    page.should have_content("Addresses")

    # table is not displayed unless addresses are available
    page.should_not have_selector("#user_addresses")
  end
end
