require 'spec_helper'

describe "LoginSignupPasswordResets" do
  describe "An unauthenticated request" do

    before(:each) do
      Capybara.current_driver = Capybara.javascript_driver
    end

    it "render the login, registration, and password reset form when request is to the root path" do
      visit root_path
      assert_equal '/', page.current_path
      assert page.has_selector?('form#login-form')
    end

  end
end
