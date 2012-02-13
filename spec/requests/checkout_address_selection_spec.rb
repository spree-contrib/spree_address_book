require 'spec_helper'

describe "Address selection during checkout" do
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
            page.should have_content(expected_address_format(billing))
          end
        end
      end

      describe "when invalid address is entered for billing", :js => true do
        let(:billing) { Factory.build(:address, :firstname => nil,
            :state => state) }
        it "should show billing address form with error" do
          fill_in_billing_address(billing)
          check "Use Billing Address"
          click_button "Save and Continue"
          within("#bfirstname") do
            page.should have_content("field is required")
          end
        end
      end

      describe "when different valid address is entered for shipping", :js => true do
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
            page.should have_content(expected_address_format(shipping))
          end
        end
      end

      describe "when invalid address is entered for shipping", :js => true do
        let(:shipping) { Factory.build(:address, :firstname => nil,
            :state => state) }
        it "should show shipping address form with error" do
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
            page.should have_content(expected_address_format(billing))
          end
        end

        it "should assign address as shipping address" do
          fill_in_billing_address(billing)
          fill_in_shipping_address(billing)
          complete_checkout
          page.should have_content("processed successfully")
          within(:css, "#order > div.row.steps-data > div:nth-child(1)") do
            page.should have_content("Shipping Address")
            page.should have_content(expected_address_format(billing))
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
        describe "and new shipping address is valid" do
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

          it "should assign selected address as billing address" do
            address = user.addresses.first
            choose "order_bill_address_id_#{address.id}"
            within("#shipping") do
              choose "Other Address"
            end
            fill_in_shipping_address(Factory.build(:address,
                :address1 => Faker::Address.street_address,
                :state => state))
            complete_checkout
            page.should have_content("processed successfully")
            within(:css, "#order > div.row.steps-data > div:nth-child(2)") do
              page.should have_content("Billing Address")
              page.should have_content(expected_address_format(address))
            end
          end

          it "should assign new address to order as shipping address" do
            address = user.addresses.first
            choose "order_bill_address_id_#{address.id}"
            within("#shipping") do
              choose "Other Address"
            end
            new_address = Factory.build(:address,
              :address1 => Faker::Address.street_address,
              :state => state)
            fill_in_shipping_address(new_address)
            complete_checkout
            page.should have_content("processed successfully")
            within(:css, "#order > div.row.steps-data > div:nth-child(1)") do
              page.should have_content("Shipping Address")
              page.should have_content(expected_address_format(new_address))
            end
          end
        end

        describe "and new address is invalid" do
          it "should see shipping address form with error" do
            address = user.addresses.first
            choose "order_bill_address_id_#{address.id}"
            within("#shipping") do
              choose "Other Address"
            end
            new_address = Factory.build(:address,
              :address1 => nil, :state => state)
            fill_in_shipping_address(new_address)
            click_button "Save and Continue"
            within("#saddress1") do
              page.should have_content("field is required")
            end
          end

          it "should have correct billing address selected" do
            address = user.addresses.first
            choose "order_bill_address_id_#{address.id}"
            within("#shipping") do
              choose "Other Address"
            end
            new_address = Factory.build(:address, :address1 => nil,
              :state => state)
            click_button "Save and Continue"
            within("#billing") do
              find("#order_bill_address_id_#{address.id}").should be_checked
            end
          end
        end

        describe "and billing address is same as shipping address" do
          it "should assign selected address as billing address" do
            address = user.addresses.first
            choose "order_bill_address_id_#{address.id}"
            check "Use Billing Address"
            complete_checkout
            within(:css, "#order > div.row.steps-data > div:nth-child(2)") do
              page.should have_content("Billing Address")
              page.should have_content(expected_address_format(address))
            end
          end

          it "should assign selected address as shipping address" do
            address = user.addresses.first
            choose "order_bill_address_id_#{address.id}"
            check "Use Billing Address"
            complete_checkout
            within(:css, "#order > div.row.steps-data > div:nth-child(1)") do
              page.should have_content("Shipping Address")
              page.should have_content(expected_address_format(address))
            end
          end

          it "should not add addresses to user" do
            expect do
              address = user.addresses.first
              choose "order_bill_address_id_#{address.id}"
              check "Use Billing Address"
              complete_checkout
            end.should_not change{ user.addresses.count }
          end
        end
      end

      describe "when old address is selected as shipping address" do
        describe "and new address is entered as billing_address" do
          describe "and new address is valid" do
            it "should add 1 new address for user" do
              expect do
                address = user.addresses.first
                choose "order_ship_address_id_#{address.id}"
                within("#billing") do
                  choose "Other Address"
                  find(".inner").should be_visible
                end
                fill_in_billing_address(
                Factory.build(:address,
                  :address1 => Faker::Address.street_address,
                  :state => state))
                complete_checkout
              end.should change{ user.addresses.count }.by(1)
            end

            it "should assign new address to order as billing address" do
              address = user.addresses.first
              choose "order_ship_address_id_#{address.id}"
              within("#billing") do
                choose "Other Address"
              end
              new_address = Factory.build(:address,
                :address1 => Faker::Address.street_address,
                :state => state)
              fill_in_billing_address(new_address)
              complete_checkout
              within(:css, "#order > div.row.steps-data > div:nth-child(2)") do
                page.should have_content("Billing Address")
                page.should have_content(expected_address_format(new_address))
              end
            end

            it "should assign select address to order as shipping address" do
              address = user.addresses.first
              choose "order_ship_address_id_#{address.id}"
              within("#billing") do
                choose "Other Address"
              end
              new_address = Factory.build(:address,
                :address1 => Faker::Address.street_address,
                :state => state)
              fill_in_billing_address(new_address)
              complete_checkout
              within(:css, "#order > div.row.steps-data > div:nth-child(1)") do
                page.should have_content("Shipping Address")
                page.should have_content(expected_address_format(address))
              end
            end
          end

          describe "and new address is invalid" do
            it "should see billing address form with error" do
              address = user.addresses.first
              choose "order_ship_address_id_#{address.id}"
              within("#billing") do
                choose "Other Address"
              end
              new_address = Factory.build(:address, :address1 => nil,
                :state => state)
              fill_in_billing_address(new_address)
              click_button "Save and Continue"
              within("#baddress1") do
                page.should have_content("field is required")
              end
            end

            it "should have old shipping address selected" do
              address = user.addresses.first
              choose "order_ship_address_id_#{address.id}"
              within("#billing") do
                choose "Other Address"
              end
              new_address = Factory.build(:address, :address1 => nil,
                :state => state)
              click_button "Save and Continue"
              within("#shipping") do
                find("#order_ship_address_id_#{address.id}").should be_checked
              end
            end
          end
        end

        describe "and shipping address is same as billing address" do
          it "should assign selected address to order as shipping address" do
            address = user.addresses.first
            choose "order_ship_address_id_#{address.id}"
            within("#billing") do
              choose "Other Address"
            end
            fill_in_billing_address(address)
            complete_checkout
            within(:css, "#order > div.row.steps-data > div:nth-child(1)") do
              page.should have_content("Shipping Address")
              page.should have_content(expected_address_format(address))
            end
          end

          it "should assign selected address to order as billing" do
            address = user.addresses.first
            choose "order_ship_address_id_#{address.id}"
            within("#billing") do
              choose "Other Address"
            end
            fill_in_billing_address(address)
            complete_checkout
            within(:css, "#order > div.row.steps-data > div:nth-child(2)") do
              page.should have_content("Billing Address")
              page.should have_content(expected_address_format(address))
            end
          end

          it "should not add new address for user" do
            expect do
              address = user.addresses.first
              choose "order_ship_address_id_#{address.id}"
              within("#billing") do
                choose "Other Address"
              end
              fill_in_billing_address(address)
              complete_checkout
            end.should_not change{ user.addresses.count }
          end
        end
      end
    end
  end
end
