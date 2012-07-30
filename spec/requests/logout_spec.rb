require 'spec_helper'

describe "Logout" do

  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver

    user = FactoryGirl.create(:user)
    visit root_path
    within('#login-form') do
      fill_in 'email', :with => user.email
      fill_in 'password', :with => user.password
    end
    click_button 'Login'
  end

  it "render login form when clicked on logout link" do
    click_link 'link-sign-out'
    assert page.has_selector?('form#login-form')
  end

end

