module Authentication
  def sign_in!(user)
    click_link "Login"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "secret"
    click_button "Login"
  end
end

RSpec.configure do |c|
  c.include Authentication, :type => :request

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  c.infer_spec_type_from_file_location!
end
