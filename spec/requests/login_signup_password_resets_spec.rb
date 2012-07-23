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

    # Logging in
    describe 'Logging in' do
      it 'show login error when login fails' do
        visit root_path
        within('#login-form') do
          fill_in 'email', :with => 'xyz@abc.org'
          fill_in 'password', :with => 'someFunky1Password'
        end
        click_button 'Login'
        assert page.has_selector?('form#login-form div.alert-error')
      end

      it 'show logged in home page when login succeeds' do
        pending 'waiting'
        user = FactoryGirl.create(:user)
        visit root_path
        within('#login-form') do
          fill_in 'email', :with => user.email
          fill_in 'password', :with => user.password
        end
        click_button 'Login'
        assert_equal '/', page.current_path
        assert page.has_selector?('a[href="'+  destroy_user_session_path + '"]')
      end
    end

  end
end
