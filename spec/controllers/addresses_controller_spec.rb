require 'spec_helper'

describe Spree::AddressesController do
  include SpecHelpers
  render_views # Needed if you want to render views in this extension...

  let(:address) { FactoryGirl.create(:address) }
  let(:user) { FactoryGirl.create(:user) }
  let(:authed_user) { create_logged_in_user }

  before {
    address.user = user
    address.save
  }

  before(:each) {
    login_as user, :scope => :user
  }

  describe "creating a new address", :js => true do
    it 'should redirect to my account page with a notice on successful save' do
      javascript :webkit, do
        visit spree.root_path
        response.status.should eq(200)

        click_link "My Account"
        response.status.should eq(200)

        click_link "Add new shipping address"
        response.should render_template(:new)

        fill_in "First Name", :with => 'John'
        fill_in "Last Name", :with => 'Doe'
        fill_in "Street Address", :with => '123 Sesame St.'
        select address.country.name, :from => 'address[country_id]'
        select address.state.name, :from => 'address[state_id]'
        fill_in "City", :with => 'New York'
        fill_in "Zip", :with => '10034'
        fill_in 'Phone', :with => '212-646-1000'

        click_button "Save"
        response.status.should eq(200)

        page.should have_content('Saved successfully')
        page.should have_content('123 Sesame St.')
      end
    end

    it 'should show errors on unsuccessful save' do
      javascript :webkit, do
        visit spree.new_address_path

        click_button "Save"
        response.should render_template(:new)
        page.should have_content("7 errors prohibited this record from being saved:")
      end
    end
  end

  # Controller methods edit and update
  describe "updating an existing address", :js => true do
    it 'should redirect to my account with notice on successful save' do
      javascript :webkit, do
        visit spree.account_path

        within('.shipping-addresses') do
          click_link "Edit"
        end
        response.should render_template(:edit)
        page.should have_content("Shipping Address")

        find_field("First Name").value.should eq(address.firstname)
        find_field("Last Name").value.should eq(address.lastname)
        find_field("Street Address").value.should eq(address.address1)
        find_field("Street Address (cont'd)").value.should eq(address.address2)
        find_field("Country").value.should eq(address.country_id.to_s)
        find_field("address_state_id").value.should eq(address.state_id.to_s)
        find_field("Phone").value.should eq(address.phone)
        find_field("Zip").value.should eq(address.zipcode)

        fill_in "First Name", :with => address.firstname + '_2'
        fill_in "Last Name", :with => address.lastname + '_2'
        fill_in "Street Address", :with => address.address1 + '_2'
        fill_in "Street Address (cont'd)", :with => address.address2 + '_2'
        fill_in "Phone", :with => address.phone + '2'
        fill_in "Zip", :with => address.zipcode + '2'
        click_button "Update"

        response.status.should eq(200)

        page.should have_content(address.firstname + '_2')
      end
    end

    it 'should not allow user to submit address edit form with empty required fields' do
      javascript :webkit, do
        visit spree.edit_address_path(address)
        fill_in "First Name", :with => ''
        fill_in "Last Name", :with => ''
        fill_in "Street Address", :with => ''
        select '', :from => 'address_state_id'
        fill_in "City", :with => ''
        fill_in "Zip", :with => ''
        fill_in "Phone", :with => ''
        click_button "Update"
        response.should render_template(:edit)

        page.should have_content("First Name can't be blank")
        page.should have_content("Last Name can't be blank")
        page.should have_content("Address can't be blank")
        page.should have_content("City can't be blank")
        page.should have_content("State can't be blank")
        page.should have_content("Zip Code can't be blank")
        page.should have_content("Phone can't be blank")
      end
    end
  end

  describe "DELETE destroy", :js => true do
    it "deletes the user's address" do
      javascript :webkit, do
        visit spree.account_path
        click_link "Delete"
        page.should have_content("No shipping addresses on file")
      end
    end
  end

end
