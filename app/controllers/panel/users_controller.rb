class Panel::UsersController < ApplicationController
	layout "dashboard"
	before_filter :authenticate_user!
	before_filter :get_data

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:id])

    lo_ids = Answer.where(user_id:@user.id, team_id:@team.id).desc("lo_id").distinct("lo_id")
    @los = Lo.find(lo_ids) | @team.los
	end

	def show
    unless @team.users.include?(current_user) || current_user.admin?
      redirect_to dashboard_home_path
    end
    @recent_activity_data = GraphDataGenerator::team_user_recent_activity(@team.id,@user.id)
		@team_user_lo_tries = GraphDataGenerator::team_user_lo_tries(@team.id,@user.id)
	end
end
