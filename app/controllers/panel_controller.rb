class PanelController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!

	def index
		@my_teams = Team.where(owner_id: current_user.id)
		@teams = current_user.teams
    @others = Array.new
    if current_user.admin?
      @others = Team.all.entries - @my_teams
		end
	end
end