RSpec.describe Spree::User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address) }
  let(:address2) { FactoryGirl.create(:address) }
  before {
    address.user = user
    address.save
    address2.user = user
    address2.save
  }

  context 'user has_many addresses' do
    it 'should have many addresses' do
      expect(user).to respond_to(:addresses)
      expect(user.addresses).to eq([address2, address])
    end
  end

end
