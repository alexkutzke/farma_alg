class WelcomeController < ApplicationController
  layout "welcome"
  skip_before_filter :authenticate_user!
  def index
    if user_signed_in?
      redirect_to dashboard_home_path
    end
  end
end
