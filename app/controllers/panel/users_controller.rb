class Panel::UsersController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!
	before_filter :get_data

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:id])
	end

	def show
	end
end