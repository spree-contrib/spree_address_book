shared_context "store products" do
  before :each do
    taxonomy = Factory(:taxonomy, :name => 'Categories')
    root = taxonomy.root

    clothing_taxon = Factory(:taxon, :name => 'Clothing',
      :parent_id => root.id)
    bags_taxon = Factory(:taxon, :name => 'Bags', :parent_id => root.id)
    mugs_taxon = Factory(:taxon, :name => 'Mugs', :parent_id => root.id)

    Factory(:custom_product, :name => 'Ruby on Rails Ringer T-Shirt',
      :price => '17.99', :taxons => [clothing_taxon],
      :on_hand => 1)
    Factory(:custom_product, :name => 'Ruby on Rails Mug', :price => '13.99',
      :taxons => [mugs_taxon], :on_hand => 10)
  end
end
