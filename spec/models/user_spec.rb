require 'spec_helper'

describe Spree::User do
  let(:user) { create(:user) }
  let(:address) { create(:address) }
  let(:address2) { create(:address) }

  before do
    address.user = user
    address.save
    sleep(1)
    address2.user = user
    address2.save
  end

  describe 'user has_many addresses' do
    it 'should have many addresses' do
      expect(user).to respond_to(:addresses)
      expect(user.addresses).to eq [address2, address]
    end
  end
end
