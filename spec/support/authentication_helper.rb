module Authentication
  def sign_in!(user)
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "secret"
    click_button "Login"
  end

  def sign_in_to_cart!(user)
    visit "/login"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "secret"
    click_button "Login"
    visit "/cart"
    click_button "Checkout"
  end
end

RSpec.configure do |c|
  c.include Authentication, :type => :feature
end
