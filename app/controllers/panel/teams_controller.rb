class Panel::TeamsController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!
	before_filter :get_team

	def get_team
		@team = Team.find(params[:id])
	end

	def show
    if not current_user.admin? and @team.owner_id != current_user.id
      redirect_to panel_team_user_path(@team, @current_user)
    end
	end
end