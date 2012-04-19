module Authentication
  def sign_in!(user)
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "secret"
    click_button "Login"
  end
end

RSpec.configure do |c|
  c.include Authentication, :type => :request
end
