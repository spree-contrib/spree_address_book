require 'spec_helper'

describe "Address selection during checkout" do
  include_context "support helper"
  include_context "store products"

  describe "as guest user" do
    include_context "checkout with product"
    before(:each) do
      visit "/cart"
      click_button "Checkout"
      fill_in "order_email", :with => "guest@example.com"
      click_button "Continue"
    end

    it "should only see billing address form" do
      within("#billing") do
        should_have_address_fields
        expect(page).to_not have_selector(".select_address")
      end
    end

    it "should only see shipping address form" do
      within("#shipping") do
        should_have_address_fields
        expect(page).to_not have_selector(".select_address")
      end
    end
  end

  describe "as authenticated user with saved addresses", :js => true do
    include_context "user with address"
    include_context "checkout with product"


    before(:each) { sign_in_to_cart!(user) }


    it "should not see billing or shipping address form" do
      expect(page.find(:xpath, '//fieldset[@id="billing"]/div[@class="inner" and contains(@style,"display: none")]'))

      # This next test fails because #shipping .inner does not get its inline style changed to "display: none" before this spec runs
      # This is only a problem when running the specs in the test app.
      # The element displays with display: none when run in nibley
      expect(page.find(:xpath, '//fieldset[@id="shipping"]/div[@class="inner" and contains(@style,"display: block")]')) #passes
      expect(page.find(:xpath, '//fieldset[@id="shipping"]/div[@class="inner" and contains(@style,"display: none")]')) #fails

      # old test:
      # find("#billing .inner").should_not be_visible
      # find("#shipping .inner").should_not be_visible
    end

    it "should list saved addresses for billing and shipping" do
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

    it "should save 2 addresses for user if they are different" do
      expect do
        within("#billing") do
          choose I18n.t(:other_address, :scope => :address_book)
          fill_in_address(billing)
        end
        within("#shipping") do
          choose I18n.t(:other_address, :scope => :address_book)
          fill_in_address(shipping, :ship)
        end
        complete_checkout
      end.to change { user.addresses.count }.by(2)
    end

    it "should save 1 address for user if they are the same" do
      expect do
        within("#billing") do
          choose I18n.t(:other_address, :scope => :address_book)
          fill_in_address(billing)
        end
        within("#shipping") do
          choose I18n.t(:other_address, :scope => :address_book)
          fill_in_address(billing, :ship)
        end
        complete_checkout
      end.to change { user.addresses.count }.by(1)
    end

    describe "when invalid address is entered" do
      let(:address) do
        Spree::Address.new(:firstname => nil, :state => state)
      end

      it "should show address form with error" do
        within("#billing") do
          fill_in_address(address)
        end
        within("#shipping") do
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

    describe "entering 2 new addresses" do
      it "should assign 2 new addresses to order" do
        within("#billing") do
          choose I18n.t(:other_address, :scope => :address_book)
          fill_in_address(billing)
        end
        within("#shipping") do
          choose I18n.t(:other_address, :scope => :address_book)
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

    describe "using saved address for bill and new ship address" do
      let(:shipping) do
        FactoryGirl.create(:address, :address1 => Faker::Address.street_address,
          :state => state)
      end

      it "should save 1 new address for user" do
        expect do
          address = user.addresses.first
          choose "order_bill_address_id_#{address.id}"
          within("#shipping") do
            choose I18n.t(:other_address, :scope => :address_book)
            fill_in_address(shipping, :ship)
          end
          complete_checkout
        end.to change{ user.addresses.count }.by(1)
      end

      it "should assign addresses to orders" do
        address = user.addresses.first
        choose "order_bill_address_id_#{address.id}"
        within("#shipping") do
          choose I18n.t(:other_address, :scope => :address_book)
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
          choose I18n.t(:other_address, :scope => :address_book)
          fill_in_address(shipping, :ship)
        end
        click_button "Save and Continue"
        within("#saddress1") do
          expect(page).to have_content("field is required")
        end
        within("#billing") do
          find("#order_bill_address_id_#{address.id}").should be_checked
        end
      end
    end

    describe "using saved address for billing and shipping" do
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

    describe "using saved address for ship and new bill address" do
      let(:billing) do
        FactoryGirl.create(:address, :address1 => Faker::Address.street_address, :state => state)
      end

      it "should save 1 new address for user" do
        expect do
          address = user.addresses.first
          choose "order_ship_address_id_#{address.id}"
          within("#billing") do
            choose I18n.t(:other_address, :scope => :address_book)
            fill_in_address(billing)
          end
          check "Use Billing Address"
          complete_checkout
        end.to change{ user.addresses.count }.by(1)
      end

      it "should assign addresses to orders" do
        choose "order_ship_address_id_#{address.id}"
        within("#billing") do
          choose I18n.t(:other_address, :scope => :address_book)
          fill_in_address(billing)
        end
        check "Use Billing Address"
        complete_checkout
        expect(page).to have_content("processed successfully")
        within("#order > div.row.steps-data > div:nth-child(1)") do
          expect(page).to have_content("Billing Address")
          expect(page).to have_content(expected_address_format(billing))
        end
        within("#order > div.row.steps-data > div:nth-child(2)") do
          expect(page).to have_content("Shipping Address")
          expect(page).to have_content(expected_address_format(billing))
        end
      end

      # TODO not passing because inline JS validation not working
      it "should see form when new billing address invalid" do
        address = user.addresses.first
        billing = FactoryGirl.build(:address, :address1 => nil, :state => state)
        choose "order_ship_address_id_#{address.id}"
        within("#billing") do
          choose I18n.t(:other_address, :scope => :address_book)
          fill_in_address(billing)
        end

        click_button "Save and Continue"
        within("#baddress1") do
          expect(page).to have_content("field is required")
        end
        within("#shipping") do
          find("#order_ship_address_id_#{address.id}").should be_checked
        end
      end
    end

    #TODO: This spec is failing because the same address can be saved multiple times
    describe "entering address that is already saved" do
      it "should not save address for user" do
        expect do
          address = user.addresses.first
          choose "order_ship_address_id_#{address.id}"
          within("#billing") do
            choose I18n.t(:other_address, :scope => :address_book)
            fill_in_address(address)
          end
          check "Use Billing Address"
          complete_checkout
        end.to_not change { user.addresses.count }
      end
    end
  end
end
