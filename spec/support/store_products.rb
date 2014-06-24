shared_context "store products" do
  before :each do
    taxonomy = FactoryGirl.create(:taxonomy, :name => 'Categories')
    root = taxonomy.root

    clothing_taxon = FactoryGirl.create(:taxon, :name => 'Clothing', :parent_id => root.id)
    bags_taxon = FactoryGirl.create(:taxon, :name => 'Bags', :parent_id => root.id)
    mugs_taxon = FactoryGirl.create(:taxon, :name => 'Mugs', :parent_id => root.id)

    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Ringer T-Shirt',
      :price => '17.99', :taxons => [clothing_taxon])
    FactoryGirl.create(:custom_product, :name => 'Ruby on Rails Mug', :price => '13.99',
      :taxons => [mugs_taxon])
  end
end

shared_context "user with address" do

  let!(:state) {  Spree::State.all.first || FactoryGirl.create(:state) }

  let!(:address) do
    FactoryGirl.create(:address, :address1 => Faker::Address.street_address, :state => state)
  end

  let!(:billing) { FactoryGirl.build(:address, :state => state) }

  let!(:shipping) do
    FactoryGirl.build(:address, :address1 => Faker::Address.street_address, :state => state)
  end

  let!(:user) do
    u = FactoryGirl.create(:user)
    u.addresses << address
    u.save
    u
  end
end
