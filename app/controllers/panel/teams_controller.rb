class Panel::TeamsController < ApplicationController
	layout "dashboard"
	before_filter :authenticate_user!
	before_filter :get_team

	def get_team
		@team = Team.find(params[:id])
    lo_ids = Answer.where(team_id:@team.id).desc("lo_id").distinct("lo_id")
    if lo_ids.empty?
      @los = @team.los
    else
      @los = Lo.find(lo_ids) | @team.los
    end

 		unless current_user.prof?
			unless current_user.team_ids.include?(@team.id)
				render_401
				return false
			end
		end

		if current_user.prof? && (not current_user.admin?)
			unless current_user.all_team_ids.include?(@team.id)
				render_401
				return false
			end
		end
	end

	def show
    if not current_user.admin? and @team.owner_id != current_user.id
      redirect_to panel_team_user_path(@team, @current_user)
    end

		@recommendations = Recommendation.all_from_team(current_user.id,@team.id)

		Log.log_team_view(current_user.id,@team.id)

    #@chart_data = GraphDataGenerator::team_tries_x_time(@team.id,"daily")
    @recent_activity_data = GraphDataGenerator::team_recent_activity(@team.id)
    @team_lo_tries = GraphDataGenerator::team_lo_tries(@team.id)

    @answers = Answer.where(team_id:@team.id).desc(:id).limit(10)
    # @answers = []
	end
end
