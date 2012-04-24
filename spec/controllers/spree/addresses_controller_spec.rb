require 'spec_helper'

describe Spree::AddressesController do
  let(:address) { FactoryGirl.create(:address) }
  let(:user) { FactoryGirl.create(:user) }

  before { address.user_id = user.id }

  describe "creating a new address" do
    it 'should redirect to my account page with a notice on successful save'
  end

  # Controller methods edit and update
  describe "updating an existing address" do
    it 'should redirect to my account with notice on successful save'
  end

  describe "DELETE destroy" do
    it "deletes the user's address"
  end

end
