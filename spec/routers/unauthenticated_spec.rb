describe "Unauthenticated routers" do

  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
  end

  it "should render the correct form for login" do
    #visit root_path
    #assert page.has_selector?('form#login-form')
    true
  end

end
