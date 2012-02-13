require 'spec_helper'

describe "Address Selection during Checkout" do
  include_context "store products"
  let(:state) { Spree::State.find_by_name('Arkansas') }

  describe "as guest user" do
    include_context "checkout with product"
    before(:each) do
      click_link "Checkout"
      fill_in "order_email", :with => "guest@example.com"
      click_button "Continue"
    end

    it "should present billing address form" do
      within("#billing") do
        page.should have_selector("#bfirstname")
        page.should have_selector("#blastname")
        page.should have_selector("#baddress1")
        page.should have_selector("#bcity")
        page.should have_selector("#bstate")
        page.should have_selector("#bcountry")
        page.should have_selector("#bzipcode")
        page.should have_selector("#bphone")
      end
    end

    it "should present shipping address form" do
      within("#shipping") do
        page.should have_selector("#sfirstname")
        page.should have_selector("#slastname")
        page.should have_selector("#saddress1")
        page.should have_selector("#scity")
        page.should have_selector("#sstate")
        page.should have_selector("#scountry")
        page.should have_selector("#szipcode")
        page.should have_selector("#sphone")
      end
    end
  end

  describe "as authenticated user" do
    include_context "checkout with product"
    let(:user) { Factory(:user) }
    before(:each) { click_link "Checkout"; sign_in!(user); }
    let(:billing) { Factory.build(:address, :state => state) }
    let(:shipping) do
      Factory.build(:address, :address1 => Faker::Address.street_address,
        :state => state)
    end
    let(:expected_format) do
      tmp = ''
      tmp << "#{billing.firstname} #{billing.lastname}: "
      tmp << "#{billing.zipcode}, #{billing.country.name}, "
      tmp << "#{billing.state.name}, #{billing.city}, #{billing.address1}"
    end

    describe "who has no addresses" do
      describe "when valid address is entered for billing", :js => true do
        it "should save 1 new address for user" do
          expect do
            fill_in_billing_address(billing)
            check "Use Billing Address"
            complete_checkout
          end.to change{ user.addresses.count }.from(0).to(1)
        end

        it "should assign new address to order as billing address" do
          fill_in_billing_address(billing)
          check "Use Billing Address"
          complete_checkout
          page.should have_content("processed successfully")
          within(:css, "#order > div.row.steps-data > div:nth-child(2)") do
            page.should have_content("Billing Address")
            page.should have_content(expected_format)
          end
        end
      end

      describe "when invalid address is entered for billing", :js => true do
        let(:billing) { Factory.build(:address, :firstname => nil,
            :state => state) }
        it "should show address entry form with error" do
          fill_in_billing_address(billing)
          check "Use Billing Address"
          click_button "Save and Continue"
          within("#bfirstname") do
            page.should have_content("field is required")
          end
        end
      end

      describe "when different valid address is entered for shipping", :js => true do
        let(:expected_format) do
          tmp = ''
          tmp << "#{shipping.firstname} #{shipping.lastname}: "
          tmp << "#{shipping.zipcode}, #{shipping.country.name}, "
          tmp << "#{shipping.state.name}, #{shipping.city}, #{shipping.address1}"
        end

        it "should save both addresses for user if they are different" do
          expect do
            fill_in_billing_address(billing)
            fill_in_shipping_address(shipping)
            complete_checkout
          end.should change { user.addresses.count }.from(0).to(2)
        end

        it "should assign address to order as shipping address" do
          fill_in_billing_address(billing)
          fill_in_shipping_address(shipping)
          complete_checkout
          page.should have_content("processed successfully")
          within(:css, "#order > div.row.steps-data > div:nth-child(1)") do
            page.should have_content("Shipping Address")
            page.should have_content(expected_format)
          end
        end
      end

      describe "when invalid address is entered for shipping", :js => true do
        let(:shipping) { Factory.build(:address, :firstname => nil,
            :state => state) }
        it "should show address entry form with error" do
          fill_in_billing_address(billing)
          fill_in_shipping_address(shipping)
          click_button "Save and Continue"
          within("#sfirstname") do
            page.should have_content("field is required")
          end
        end
      end

      describe "when shipping address same as billing address", :js => true do
        it "should save 1 address for user" do
          expect do
            fill_in_billing_address(billing)
            fill_in_shipping_address(billing)
            complete_checkout
          end.should change { user.addresses.count }.from(0).to(1)
        end

        it "should assign address as billing address" do
          fill_in_billing_address(billing)
          fill_in_shipping_address(billing)
          complete_checkout
          page.should have_content("processed successfully")
          within(:css, "#order > div.row.steps-data > div:nth-child(2)") do
            page.should have_content("Billing Address")
            page.should have_content(expected_format)
          end
        end

        it "should assign address as shipping address" do
          fill_in_billing_address(billing)
          fill_in_shipping_address(billing)
          complete_checkout
          page.should have_content("processed successfully")
          within(:css, "#order > div.row.steps-data > div:nth-child(1)") do
            page.should have_content("Shipping Address")
            page.should have_content(expected_format)
          end
        end
      end
    end

    describe "who has addresses", :js => true do
      let(:user) do
        u = Factory(:user)
        u.addresses << Factory(:address,
          :address1 => Faker::Address.street_address,
          :state => state)
        u.addresses << Factory(:address,
          :address1 => Faker::Address.street_address,
          :state => state)
        u.save
        u
      end

      it "should not see billing address form" do
        find("#billing .inner").should_not be_visible
      end

      it "should not see shipping address form" do
        find("#shipping .inner").should_not be_visible
      end

      it "should list addresses under billing" do
        within("#billing .select_address") do
          user.addresses.each do |a|
            page.should have_selector("input#order_bill_address_id_#{a.id}")
          end
        end
      end

      it "should list addresses under shipping" do
        within("#shipping .select_address") do
          user.addresses.each do |a|
            page.should have_selector("input#order_ship_address_id_#{a.id}")
          end
        end
      end

      describe "when old address is selected as billing address" do
        describe "and new shipping address is valid", :js => true do
          it "should add 1 new address for the user" do
            expect do
              address = user.addresses.first
              choose "order_bill_address_id_#{address.id}"
              within("#shipping") do
                choose "Other Address"
                find(".inner").should be_visible
              end
              fill_in_shipping_address(
                Factory.build(:address,
                  :address1 => Faker::Address.street_address,
                  :state => state))
              complete_checkout
            end.should change{ user.addresses.count }.by(1)
          end

          pending "should assign selected address as billing address"
          pending "should assign old address to order as billing address"
          pending "should assign new address to order as shipping address"
        end

        describe "and new address is invalid" do
          pending "should show shipping address form"
          pending "should have old billing address selected"
        end

        describe "and billing address is same as shipping address" do
          pending "should assign old address to order as billing"
          pending "should assign old address to order as shipping"
          pending "should not add addresses to user"
        end
      end

      describe "when old address is selected as shipping address" do
        describe "and new address is entered as billing_address" do
          describe "and new address is valid" do
            pending "should add 1 new address for user"
            pending "should assign new address to order as billing address"
            pending "should assign old address to order as shipping address"
          end

          describe "and new address is invalid" do
            pending "should show billing address form"
            pending "should have old shipping address selected"
          end
        end

        describe "and shipping address is same as billing address" do
          pending "should not add new address"
          pending "should assign old address to order as shipping address"
          pending "should assign old address to order as billing address"
        end
      end
    end
  end
end
