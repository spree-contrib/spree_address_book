shared_context "checkout with product" do
  before :each do
    @zone = Spree::Zone.find_by_name('GlobalZone') || Factory(:global_zone)
    @shipping = Spree::ShippingMethod.find_by_name('UPS Ground') ||
      Factory(:shipping_method)
    Factory(:payment_method)
    visit spree.root_path
    click_link 'Ruby on Rails Mug'
    click_button 'add-to-cart-button'
  end

  private
  def complete_checkout
    click_button "Save and Continue"
    choose "UPS Ground"
    click_button "Save and Continue"
    choose "Check"
    click_button "Save and Continue"
  end

  def fill_in_billing_address(address)
    within("#billing") do
      fill_in "First Name", :with => address.firstname
      fill_in "Last Name", :with => address.lastname
      fill_in "Street Address", :with => address.address1
      select address.state.name, :from => "order_bill_address_attributes_state_id"
      fill_in "City", :with => address.city
      fill_in "Zip", :with => address.zipcode
      fill_in "Phone", :with => address.phone
    end
  end

  def fill_in_shipping_address(address)
    within("#shipping") do
      fill_in "First Name", :with => address.firstname
      fill_in "Last Name", :with => address.lastname
      fill_in "Street Address", :with => address.address1
      select address.state.name, :from => "order_ship_address_attributes_state_id"
      fill_in "City", :with => address.city
      fill_in "Zip", :with => address.zipcode
      fill_in "Phone", :with => address.phone
    end
  end
end
