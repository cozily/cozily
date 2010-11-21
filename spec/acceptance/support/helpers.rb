module HelperMethods
  def login_as(user)
    visit root_path

    click_link "Sign in"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_button "Sign in"

    page.should have_content("Hi #{user.first_name}")
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
