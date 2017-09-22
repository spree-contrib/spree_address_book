module Authentication
  def sign_in!(user)
    visit spree.login_path
    within '#new_spree_user' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Login'
  end
end

RSpec.configure do |c|
  c.include Authentication, type: :feature
end
