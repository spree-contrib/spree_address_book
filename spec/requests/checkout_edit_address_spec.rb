require 'spec_helper'

describe "User editing saved address during checkout", :js => true do
  include_context "store products"
  include_context "checkout with product"
  let(:state) {  Spree::State.all.first || FactoryGirl.create(:state) }
  let(:address) do
    Factory(:address,
      :address1 => Faker::Address.street_address,
      :state => state)
  end
  let(:user) do
    u = Factory(:user)
    u.addresses << address
    u.save
    u
  end

  before(:each) { click_link "Checkout"; sign_in!(user) }

  it "can update billing address" do
    within("#billing #spree_address_#{address.id}") do
      click_link "Edit"
    end
    current_path.should == spree.edit_address_path(address)
    new_street = Faker::Address.street_address
    fill_in "Street Address", :with => new_street
    click_button "Update"
    current_path.should == spree.checkout_path
    within("h3") { page.should have_content("Checkout") }
    within("#billing") do
      page.should have_content(new_street)
    end
  end

  it "can update shipping address" do
    within("#shipping #spree_address_#{address.id}") do
      click_link "Edit"
    end
    current_path.should == spree.edit_address_path(address)
    new_street = Faker::Address.street_address
    fill_in "Street Address", :with => new_street
    click_button "Update"
    current_path.should == spree.checkout_path
    within("h3") { page. should have_content("Checkout") }
    within("#shipping") do
      page.should have_content(new_street)
    end
  end
end
