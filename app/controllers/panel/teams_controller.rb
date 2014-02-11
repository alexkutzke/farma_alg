class Panel::TeamsController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!
	before_filter :get_team

	def get_team
		@team = Team.find(params[:id])
	end

	def show
	end
end