module Authentication
  def sign_in!(user)
    fill_in "spree_user_email", :with => user.email
    fill_in "Password", :with => "secret"
    click_button "Login"
  end
end

RSpec.configure do |c|
  c.include Authentication
end
