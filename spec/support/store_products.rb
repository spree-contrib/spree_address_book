shared_context "store products" do
  before :each do
    taxonomy = Factory(:taxonomy, :name => 'Categories')
    root = taxonomy.root

    clothing_taxon = Factory(:taxon, :name => 'Clothing', :parent_id => root.id)
    bags_taxon = Factory(:taxon, :name => 'Bags', :parent_id => root.id)
    mugs_taxon = Factory(:taxon, :name => 'Mugs', :parent_id => root.id)

    Factory(:custom_product, :name => 'Ruby on Rails Ringer T-Shirt',
      :price => '17.99', :taxons => [clothing_taxon],
      :on_hand => 1)
    Factory(:custom_product, :name => 'Ruby on Rails Mug', :price => '13.99',
      :taxons => [mugs_taxon],
      :on_hand => 10)
  end
end

shared_context "user with address" do
  let(:state) {  Spree::State.all.first || FactoryGirl.create(:state) }

  let(:address) do
    Factory(:address, :address1 => Faker::Address.street_address, :state => state)
  end

  let(:billing) { Factory.build(:address, :state => state) }
  let(:shipping) do
    Factory.build(:address, :address1 => Faker::Address.street_address, :state => state)
  end

  let(:user) do
    u = Factory(:user)
    u.addresses << address
    u.save
    u
  end
end