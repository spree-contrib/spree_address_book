require 'spec_helper'

describe Spree::AddressesController do
  let(:address) { FactoryGirl.create(:address) }
  let(:user) { FactoryGirl.create(:user) }

  before {
    address.user_id = user.id
    sign_in(user)
  }

  describe "creating a new address" do
    it 'should redirect to my account page with a notice on successful save' do
      visit spree.new_address_path
      response.should render_template(:new)

      post :create, :address => {
        :firstname => 'John', :lastname => 'Doe',
        :address1 => '123 Sesame St.',
        :city => 'New York', :zipcode => 10034,
        :phone => '212-646-1000', :state_id => 889445952,
        :country_id => 214,
      }
      response.should redirect_to('/account')
    end
  end

  # Controller methods edit and update
  describe "updating an existing address" do
    it 'should redirect to my account with notice on successful save'
  end

  describe "DELETE destroy" do
    it "deletes the user's address"
  end

end
