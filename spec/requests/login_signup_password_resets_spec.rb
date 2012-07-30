require 'spec_helper'

describe "LoginSignupPasswordResets" do

  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
  end

  describe "An unauthenticated request" do

    it "render the login, registration, and password reset form when request is to the root path" do
      visit root_path
      assert_equal '/users/sign-in', page.current_path
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
        user = FactoryGirl.create(:user)
        visit root_path
        within('#login-form') do
          fill_in 'email', :with => user.email
          fill_in 'password', :with => user.password
        end
        click_button 'Login'
        assert_equal root_path, page.current_path
        assert page.has_selector?('a[href="'+  destroy_user_session_path + '"]')
      end
    end
  end

  describe 'Signing up' do
      it 'show logged in home page when signup succeeds'  do
        visit root_path
        click_link 'sign_up_link'
        wait_until { page.has_selector?('#signup-form', :visible => true) }
        attrs = FactoryGirl.attributes_for(:user)
        within('#signup-form') do
          fill_in 'name', :with => attrs[:name]
          fill_in 'email', :with => attrs[:email]
          fill_in 'password', :with => attrs[:password]
          fill_in 'password_confirmation', :with => attrs[:password_confirmation]
        end
        click_button 'sign_up_btn'
        assert_equal root_path, page.current_path
        assert page.has_selector?('a[href="'+  destroy_user_session_path + '"]')
     end

     it 'show an error message when signup fails' do
        visit root_path
        click_link 'sign_up_link'
        wait_until { page.has_selector?('#signup-form', :visible => true) }
        within('#signup-form') do
          fill_in 'email', :with => 'someone@example.org'
          fill_in 'password', :with => '123'
          fill_in 'password_confirmation', :with => '1234567'
        end
        click_button 'sign_up_btn'
        assert page.has_selector?('form#signup-form div.alert-error')
    end
  end

  # Password reset
  describe 'Resetting your password' do
    it 'show success message when reset submission succeeds' do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link 'retrieve_password'
      wait_until { page.has_selector?('#retrieve-password-form', :visible => true) }
      within('#retrieve-password-form') do
        fill_in 'email', :with => user.email
      end
      click_button 'reset_password'
      assert page.has_selector?('form#retrieve-password-form div.alert-success')
    end

    it 'show an error message when reset fails' do
      visit root_path
      click_link 'retrieve_password'
      wait_until { page.has_selector?('#retrieve-password-form', :visible => true) }
      within('#retrieve-password-form') do
        fill_in 'email', :with => 'someone@else.com'
      end
      click_button 'reset_password'
      assert page.has_selector?('form#retrieve-password-form div.alert-error')
    end
  end
end
