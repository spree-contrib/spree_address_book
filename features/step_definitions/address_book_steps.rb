Given /^an order from registered user "([^"]*)" at address step$/ do |user_data|
  Given "a shipping method exists"
  Given "a payment method exists"
  Given "I am signed up as \"#{user_data}\""
  Given "I add a product with name: \"RoR Mug\" to cart"
  Given "I follow \"Checkout\""
  Given "I sign in as \"email@person.com/password\""
end

Then /^user "([^"]*)" should have (\d+) address$/ do |email, count|
  User.find_by_email(email).addresses.count.should == count.to_i
end
