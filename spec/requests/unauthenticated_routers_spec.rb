require 'spec_helper'

describe "Unauthenticated routers" do

  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
  end

  describe "not logged" do
    it "visit root path should see login form" do
      visit root_path
      page.has_selector?('form#login-form').should be_true
      page.current_path.should == '/users/sign-in'
    end

    it "visit /users/sigin-in should see login form" do
      visit '/users/sign-in'
      page.has_selector?('form#login-form').should be_true
    end


    it "visit /users/sigin-up should see sing-up form" do
      visit '/users/sign-up'
      page.has_selector?('form#signup-form').should be_true
    end

    it "visit /users/sign-up should see retrive passwords form" do
      visit '/users/passwords'
      page.has_selector?('form#retrieve-password-form').should be_true
    end

    it "visit a url that not exists I should see a error message and redirect to home page" do
      visit '/usasdf/asdf'
      page.current_path.should == '/users/sign-in'
      page.has_selector?('div.alert-error').should be_true
    end
  end

  describe "logged in" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit root_path
      within('#login-form') do
        fill_in 'email', :with => @user.email
        fill_in 'password', :with => @user.password
      end
      click_button 'Login'
    end

    it "visit root path should see login form" do
      visit root_path
      page.current_path.should == '/'
      page.has_content?(@user.name)
    end

    it "visit /users/sigin-in should see login form" do
      visit '/users/sign-in'
      page.has_selector?('div.alert').should be_true
    end


    it "visit /users/sigin-up should see sing-up form" do
      visit '/users/sign-up'
      page.has_selector?('div.alert').should be_true
    end

    it "visit /users/sign-up should see retrive passwords form" do
      visit '/users/passwords'
      page.has_selector?('div.alert').should be_true
    end

    it "visit a url that not exists I should see a error message and redirect to home page", focus: true do
      visit '/usasdf/asdf'
      page.current_path.should == "/"
      page.has_selector?('div.alert-error').should be_true
    end
  end

end
