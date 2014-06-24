shared_context "checkout with product" do

  let!(:mug) { FactoryGirl.create(:product, :name => "RoR Mug") }
  let!(:order) { FactoryGirl.create(:order_with_totals, :state => 'cart') }
  let!(:shipping_method) {
    # A shipping method must exist for rates to be displayed on checkout page
    FactoryGirl.create(:shipping_method).tap do |sm|
      sm.calculator.preferred_amount = 10
      sm.calculator.preferred_currency = Spree::Config[:currency]
      sm.calculator.save
      sm
    end
  }

  before :each do

    # A payment method must exist for an order to proceed through the Address state
    unless Spree::PaymentMethod.exists?
      FactoryGirl.create(:check_payment_method)
    end

    # Need to create a valid zone too...
    zone = FactoryGirl.create(:zone)
    country = FactoryGirl.create(:country)
    zone.members << Spree::ZoneMember.create(:zoneable => country)
    country.states << FactoryGirl.create(:state, :country => country)

    mug.shipping_category = shipping_method.shipping_categories.first
    mug.save!


    reset_spree_preferences do |config|
      config.address_requires_state = true
      config.alternative_shipping_phone = true
      config.company = true
    end

    Capybara.ignore_hidden_elements = false

    add_mug_to_cart

  end

  after :each do
    Capybara.ignore_hidden_elements = true
  end

  private
  def should_have_address_fields
    expect(page).to have_field("First Name")
    expect(page).to have_field("Last Name")
    expect(page).to have_field(Spree.t(:address1))
    expect(page).to have_field("City")
    expect(page).to have_field("Country")
    expect(page).to have_field(Spree.t(:zip))
    expect(page).to have_field(Spree.t(:phone))
  end

  def complete_checkout
    click_button Spree.t(:save_and_continue)
    choose "UPS Ground"
    click_button Spree.t(:save_and_continue)
    choose "Check"
    click_button Spree.t(:save_and_continue)
  end

  def fill_in_address(address, type = :bill)
    fill_in Spree.t(:first_name), :with => address.firstname
    fill_in "Last Name", :with => address.lastname
    fill_in "Company", :with => address.company if Spree::Config[:company]
    fill_in Spree.t(:address1), :with => address.address1
    fill_in Spree.t(:address2), :with => address.address2
    select address.state.name, :from => "order_#{type}_address_attributes_state_id"
    fill_in Spree.t(:city), :with => address.city
    fill_in Spree.t(:zip), :with => address.zipcode
    fill_in Spree.t(:phone), :with => address.phone
    fill_in Spree.t(:alternative_phone), :with => address.alternative_phone if (Spree::Config[:alternative_shipping_phone] && type == :ship)
  end

  def expected_address_format(address)
    Nokogiri::HTML(address.to_s).text
  end

  def add_mug_to_cart
    visit spree.root_path
    click_link mug.name
    click_button "add-to-cart-button"
  end

end
