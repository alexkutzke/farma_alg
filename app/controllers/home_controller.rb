class HomeController < ApplicationController
  def index
  end

  def lo_example
    @lo = Lo.first
  end
end
