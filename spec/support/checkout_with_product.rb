shared_context "checkout with product" do
  before :each do
    @state = Spree::State.all.first || FactoryGirl.create(:state)
    @zone = Spree::Zone.find_by_name('GlobalZone') || FactoryGirl.create(:global_zone)
    @shipping = Spree::ShippingMethod.find_by_name('UPS Ground') || FactoryGirl.create(:shipping_method)

    FactoryGirl.create(:payment_method)
    reset_spree_preferences do |config|
      config.company = true
      config.alternative_billing_phone = true
      config.alternative_shipping_phone = true
    end

    visit spree.root_path
    click_link 'Ruby on Rails Mug'
    click_button 'add-to-cart-button'
  end

  let(:state) { @state }

  private
  def should_have_address_fields
    page.should have_field("First Name")
    page.should have_field("Last Name")
    page.should have_field(I18n.t('activerecord.attributes.spree/address.address1'))
    page.should have_field("City")
    page.should have_field("Country")
    page.should have_field(I18n.t(:zip))
    page.should have_field(I18n.t(:phone))
  end

  def complete_checkout
    click_button I18n.t(:save_and_continue)
    choose "UPS Ground"
    click_button I18n.t(:save_and_continue)
    choose "Check"
    click_button I18n.t(:save_and_continue)
  end

  def fill_in_address(address, type = :bill)
    fill_in I18n.t(:first_name), :with => address.firstname
    fill_in "Last Name", :with => address.lastname
    fill_in "Company", :with => address.company if Spree::Config[:company]
    fill_in I18n.t('activerecord.attributes.spree/address.address1'), :with => address.address1
    fill_in I18n.t('activerecord.attributes.spree/address.address2'), :with => address.address2
    select address.state.name, :from => "order_#{type}_address_attributes_state_id"
    fill_in I18n.t(:city), :with => address.city
    fill_in I18n.t(:zip), :with => address.zipcode
    fill_in I18n.t(:phone), :with => address.phone
    fill_in 'Alternative phone', :with => address.alternative_phone if Spree::Config[:alternative_billing_phone]
  end

  def expected_address_format(address)
    Nokogiri::HTML(address.to_s).text
  end
end
