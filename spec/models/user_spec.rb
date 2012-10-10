require 'spec_helper'

describe Spree::User do
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address) }
  let(:address2) { FactoryGirl.create(:address) }
  before {
    address.user = user
    address.save
    address2.user = user
    address2.save
  }

  describe 'user has_many addresses' do
    it 'should have many addresses' do
      user.should respond_to(:addresses)
      user.addresses.should eq([address2, address])
    end
  end

end
