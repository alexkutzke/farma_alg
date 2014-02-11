class PanelController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!

	def index
		@my_teams = Team.where(owner_id: current_user.id)
		@teams = Array.new
		current_user.teams.each do |t|
			unless t.owner_id == current_user.id
				@teams << t
			end 
		end
	end
end