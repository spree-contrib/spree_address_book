require 'spec_helper'

describe "User editing addresses for his account" do
  let(:state) {  Spree::State.all.first || FactoryGirl.create(:state) }
  let(:address) do
    Factory(:address, :address1 => Faker::Address.street_address,
      :state => state)
  end
  let(:user) do
    u = Factory(:user)
    u.addresses << address
    u.save
    u
  end
  before(:each) do
    visit spree.root_path
    click_link "Login"
    sign_in!(user)
    click_link "My Account"
  end

  it "should see list of addresses saved for account" do
    page.should have_content("Addresses")
    within("#user-address-list") do
      page.should have_selector("li.spree_address", :count => user.addresses.count)
    end
  end

  it "should be able to edit address" do
    new_street = Faker::Address.street_address
    within("#user-address-list > li:first .controls") do
      click_link "Edit"
    end
    current_path.should == spree.edit_address_path(address)
    fill_in "Street Address", :with => new_street
    click_button "Update"
    current_path.should == spree.account_path
    page.should have_content("updated")
    within("#user-address-list > li:first") do
      page.should have_content(new_street)
    end
  end

  it "should be able to remove address", :js => true do
    # bypass confirm dialog
    page.evaluate_script('window.confirm = function() { return true; }')
    within("#user-address-list > li:first .controls") do
      click_link "Remove"
    end
    current_path.should == spree.account_path
    page.should have_content("removed")
    page.should_not have_content("Addresses")
    page.should_not have_selector("#user-address-list")
  end
end
