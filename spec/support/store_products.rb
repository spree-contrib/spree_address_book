shared_context 'store products' do
  before :each do
    taxonomy = create(:taxonomy, name: 'Categories')
    root = taxonomy.root
    # create(:shipping_method)
    clothing_taxon = create(:taxon, name: 'Clothing', parent_id: root.id)
    bags_taxon = create(:taxon, name: 'Bags', parent_id: root.id)
    mugs_taxon = create(:taxon, name: 'Mugs', parent_id: root.id)

    create(:product_in_stock, name: 'Ruby on Rails Ringer T-Shirt',
                              price: 17.99, taxons: [clothing_taxon])
    create(:product_in_stock, name: 'Ruby on Rails Mug', price: 13.99,
                              taxons: [mugs_taxon])
  end
end

shared_context 'user with address' do
  let(:state) { Spree::State.all.first || create(:state) }

  let(:address) do
    create(:address, address1: FFaker::Address.street_address, state: state)
  end

  let(:billing) { build(:address, state: state) }
  let(:shipping) do
    build(:address, address1: FFaker::Address.street_address, state: state)
  end

  let(:user) do
    u = create(:user)
    u.addresses << address
    u.save
    u
  end
end
