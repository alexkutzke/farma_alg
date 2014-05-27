class DashboardController < ApplicationController
	layout "dashboard"

	def home
	end

  def timeline
  end

  def search
  end

  def fulltext_search
    @as = Answer.search(params)

    render 'search_result'
  end
end