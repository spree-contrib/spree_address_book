RSpec.describe "Address selection during checkout", type: :feature do
  include_context "store products"

  let(:state) {  Spree::State.all.first || FactoryGirl.create(:state) }

  context "as guest user" do
    include_context "checkout with product"
    before(:each) do
      click_button "Checkout"
      fill_in "order_email", :with => "guest@example.com"
      click_button "Continue"
    end

    it "should only see billing address form", :js => true do
      within("#billing") do
        should_have_address_fields
        expect(page).not_to have_selector(".select_address")
      end
    end

    it "should only see shipping address form" do
      within("#shipping") do
        should_have_address_fields
        expect(page).not_to have_selector(".select_address")
      end
    end
  end

  context "as authenticated user with saved addresses", :js => true do
    include_context "checkout with product"
    # include_context "user with address"

    let(:billing) { FactoryGirl.build(:address, :state => state) }
    let(:shipping) do
      FactoryGirl.build(:address, :address1 => Faker::Address.street_address, :state => state)
    end
    let(:user) do
      u = FactoryGirl.create(:user)
      u.addresses << FactoryGirl.create(:address, :address1 => Faker::Address.street_address, :state => state, :state_name => '')
      u.save
      u
    end

    before(:each) { click_button "Checkout"; sign_in!(user); }
  
    it "should not see billing or shipping address form" do
      expect(page.find('#billing .inner', :visible => false)).not_to be_visible
      expect(page.find('#shipping .inner', :visible => false)).not_to be_visible
    end
  
    it "should list saved addresses for billing and shipping" do
      uncheck 'order_use_billing'
      within("#billing .select_address") do
        user.addresses.each do |a|
          expect(page).to have_field("order_bill_address_id_#{a.id}")
        end
      end
      within("#shipping .select_address") do
        user.addresses.each do |a|
          expect(page).to have_field("order_ship_address_id_#{a.id}")
        end
      end
    end
      
    it "should save 2 addresses for user if they are different", :js => true do
      expect do
        within("#billing") do
          choose I18n.t('address_book.other_address')
          fill_in_address(billing)
        end
        within("#shipping") do
          uncheck 'order_use_billing'
          choose I18n.t('address_book.other_address')
          fill_in_address(shipping, :ship)
        end
        complete_checkout
      end.to change { user.addresses.count }.by(2)
    end
  
    it "should save 1 address for user if they are the same" do
      expect do
        within("#billing") do
          choose I18n.t('address_book.other_address')
          fill_in_address(billing)
        end
        within("#shipping") do
          uncheck 'order_use_billing'
          choose I18n.t('address_book.other_address')
          fill_in_address(billing, :ship)
        end
        complete_checkout
      end.to change { user.addresses.count }.by(1)
    end
      
    context "when invalid address is entered", :js => true do
      let(:address) do
        FactoryGirl.build(:address, :firstname => nil, :state => state)
      end
      
      # TODO the JS error reporting isn't working with our current iteration
      # this is what this piece of code ('field is required') tests
      it "should show address form with error" do
        within("#billing") do
          choose I18n.t('address_book.other_address')
          fill_in_address(address)
        end
        within("#shipping") do
          uncheck 'order_use_billing'
          choose I18n.t('address_book.other_address')
          fill_in_address(address, :ship)
        end
        click_button "Save and Continue"
        within("#bfirstname") do
          expect(page).to have_content("field is required")
        end
        within("#sfirstname") do
          expect(page).to have_content("field is required")
        end
      end
    end
  
    context "entering 2 new addresses", :js => true do
      it "should assign 2 new addresses to order" do
        within("#billing") do
          choose I18n.t('address_book.other_address')
          fill_in_address(billing)
        end
        within("#shipping") do
          uncheck 'order_use_billing'
          choose I18n.t('address_book.other_address')
          fill_in_address(shipping, :ship)
        end
        complete_checkout
        expect(page).to have_content("processed successfully")
        within("#order > div.row.steps-data > div:nth-child(1)") do
          expect(page).to have_content("Billing Address")
          expect(page).to have_content(expected_address_format(billing))
        end
        within("#order > div.row.steps-data > div:nth-child(2)") do
          expect(page).to have_content("Shipping Address")
          expect(page).to have_content(expected_address_format(shipping))
        end
      end
    end
  
    context "using saved address for bill and new ship address", :js => true do
      let(:shipping) do
        FactoryGirl.build(:address, :address1 => Faker::Address.street_address,
          :state => state)
      end
  
      it "should save 1 new address for user" do
        expect do
          address = user.addresses.first
          choose "order_bill_address_id_#{address.id}"
          within("#shipping") do
            uncheck 'order_use_billing'
            choose I18n.t('address_book.other_address')
            fill_in_address(shipping, :ship)
          end
          complete_checkout
        end.to change{ user.addresses.count }.by(1)
      end
  
      it "should assign addresses to orders" do
        address = user.addresses.first
        choose "order_bill_address_id_#{address.id}"
        within("#shipping") do
          uncheck 'order_use_billing'
          choose I18n.t('address_book.other_address')
          fill_in_address(shipping, :ship)
        end
        complete_checkout
        expect(page).to have_content("processed successfully")
        within("#order > div.row.steps-data > div:nth-child(1)") do
          expect(page).to have_content("Billing Address")
          expect(page).to have_content(expected_address_format(address))
        end
        within("#order > div.row.steps-data > div:nth-child(2)") do
          expect(page).to have_content("Shipping Address")
          expect(page).to have_content(expected_address_format(shipping))
        end
      end
  
      it "should see form when new shipping address invalid" do
        address = user.addresses.first
        shipping = FactoryGirl.build(:address, :address1 => nil, :state => state)
        choose "order_bill_address_id_#{address.id}"
        within("#shipping") do
          uncheck 'order_use_billing'
          choose I18n.t('address_book.other_address')
          fill_in_address(shipping, :ship)
        end
        click_button "Save and Continue"
        within("#saddress1") do
          expect(page).to have_content("field is required")
        end
        within("#billing") do
          expect(find("#order_bill_address_id_#{address.id}")).to be_checked
        end
      end
    end
  
    context "using saved address for billing and shipping", :js => true do
      it "should addresses to order" do
        address = user.addresses.first
        choose "order_bill_address_id_#{address.id}"
        check "Use Billing Address"
        complete_checkout
        within("#order > div.row.steps-data > div:nth-child(1)") do
          expect(page).to have_content("Billing Address")
          expect(page).to have_content(expected_address_format(address))
        end
        within("#order > div.row.steps-data > div:nth-child(2)") do
          expect(page).to have_content("Shipping Address")
          expect(page).to have_content(expected_address_format(address))
        end
      end
  
      it "should not add addresses to user" do
        expect do
          address = user.addresses.first
          choose "order_bill_address_id_#{address.id}"
          check "Use Billing Address"
          complete_checkout
        end.to_not change{ user.addresses.count }
      end
    end
  
    context "using saved address for ship and new bill address", :js => true do
      let(:billing) do
        FactoryGirl.build(:address, :address1 => Faker::Address.street_address, :state => state)
      end
  
      it "should save 1 new address for user" do
        expect do
          address = user.addresses.first
          uncheck 'order_use_billing'
          choose "order_ship_address_id_#{address.id}"
          within("#billing") do
            choose I18n.t('address_book.other_address')
            fill_in_address(billing)
          end
          complete_checkout
        end.to change{ user.addresses.count }.by(1)
      end
  
      it "should assign addresses to orders" do
        address = user.addresses.first
        uncheck 'order_use_billing'
        choose "order_ship_address_id_#{address.id}"
        within("#billing") do
          choose I18n.t('address_book.other_address')
          fill_in_address(billing)
        end
        complete_checkout
        expect(page).to have_content("processed successfully")
        within("#order > div.row.steps-data > div:nth-child(1)") do
          expect(page).to have_content("Billing Address")
          expect(page).to have_content(expected_address_format(billing))
        end
        within("#order > div.row.steps-data > div:nth-child(2)") do
          expect(page).to have_content("Shipping Address")
          expect(page).to have_content(expected_address_format(address))
        end
      end

      it "should see form when new billing address invalid" do
        address = user.addresses.first
        billing = FactoryGirl.build(:address, :address1 => nil, :state => state)
        uncheck 'order_use_billing'
        choose "order_ship_address_id_#{address.id}"
        within("#billing") do
          choose I18n.t('address_book.other_address')
          fill_in_address(billing)
        end

        click_button "Save and Continue"
        within("#baddress1") do
          expect(page).to have_content("field is required")
        end
        within("#shipping") do
          expect(find("#order_ship_address_id_#{address.id}")).to be_checked
        end
      end
    end
  
    context "entering address that is already saved", :js => true do
      it "should not save address for user" do
        expect do
          address = user.addresses.first
          uncheck 'order_use_billing'
          choose "order_ship_address_id_#{address.id}"
          within("#billing") do
            choose I18n.t('address_book.other_address')
            fill_in_address(address)
          end
          complete_checkout
        end.to_not change { user.addresses.count }
      end
    end
  end
end
