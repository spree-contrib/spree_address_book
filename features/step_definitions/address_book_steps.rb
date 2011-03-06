Given /^an order from registered user "([^"]*)", who has (\d+) addresses, at address step$/ do |user_data, addresses_count|
  Given "a shipping method exists"
  Given "a payment method exists"
  Given "I am signed up as \"#{user_data}\""
  Given "user \"#{user_data}\" has #{addresses_count} addresses"
  Given "I add a product with name: \"RoR Mug\" to cart"
  Given "I follow \"Checkout\""
  Given "I sign in as \"email@person.com/password\""
end

Then /^user "([^"]*)" should have (\d+) address$/ do |email, count|
  User.find_by_email(email).addresses.count.should == count.to_i
end

Given /^user "([^"]*)" has (\d+) addresses$/ do |user_data, count|
  user = User.find_by_email(user_data.split('/')[0])
  state = State.first
  count.to_i.times do
    Factory(:address, :state => state, :user => user)
  end
end
