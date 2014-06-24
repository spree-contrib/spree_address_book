require 'spec_helper'

describe 'spree/addresses/new' do
  let(:address) { FactoryGirl.build(:address) }

  it 'renders new.html.erb for new address' do
    assign(:address, address)
    render :template => 'spree/addresses/new', :address => address

    rendered.should have_content('New Shipping Address')

    rendered.should have_field('First Name', :type => 'text')
    rendered.should have_field('Last Name', :type => 'text')
    rendered.should have_field(Spree.t(:address1), :type => 'text')
    rendered.should have_field(Spree.t(:address2), :type => 'text')
    # Javascript can't be tested in views spec
    rendered.should have_selector('select#address_country_id')
    # Javascript can't be tested in views spec
    rendered.should have_selector('input#address_state_name')
    rendered.should have_field('City', :type => 'text')
    rendered.should have_field('Zip', :type => 'text')
    rendered.should have_field('Phone', :type => 'text')
  end

end

describe 'spree/addresses/edit' do
  let(:address) { FactoryGirl.create(:address) }

  it 'renders edit.html.erb for editing an existing address' do
    assign(:address, address)
    render :template => 'spree/addresses/edit', :address => address

    rendered.should have_field('First Name', :with => address.firstname, :type => 'text')
    rendered.should have_field('Last Name', :with => address.lastname, :type => 'text')
    rendered.should have_field(Spree.t(:address1), :with => address.address1, :type => 'text')
    rendered.should have_field(Spree.t(:address2), :with => address.address2, :type => 'text')
    # Javascript can't be tested in views spec
    rendered.should have_selector('select#address_country_id')
    # Javascript can't be tested in views spec
    rendered.should have_selector('input#address_state_name')
    rendered.should have_field('City', :with => address.city, :type => 'text')
    rendered.should have_field('Zip', :with => address.zipcode, :type => 'text')
    rendered.should have_field('Phone', :with => address.phone, :type => 'text')
  end
end


# a few methods to deal with problems in the views, due to the usage of form_for @address.
def address_path(address, format)
  return spree.address_path(address, format)
end

def addresses_path(format)
  return spree.addresses_path(format)
end

# I'm not sure why this method isn't available, or how to make it available, so
# I've cloned it from Spree::BaseHelper.
def available_countries
  countries = Spree::Zone.find_by_name(Spree::Config[:checkout_zone]).try(:country_list) || Spree::Country.all
  countries.collect do |c|
    c.name = t(c.name, :scope => 'countries', :default => c.name)
    c
  end.sort{ |a,b| a.name <=> b.name }
end
