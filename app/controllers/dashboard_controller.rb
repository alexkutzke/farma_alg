class DashboardController < ApplicationController
	layout "dashboard"

	def home
	end

  def timeline
  end

  def search
  end

  def fulltext_search
    @as = Answer.fulltext_search(params[:query],{:max_results => 50000 })

    render 'search_result'
  end
end