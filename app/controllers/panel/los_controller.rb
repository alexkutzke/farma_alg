class Panel::LosController < ApplicationController
	layout "dashboard"
	before_filter :authenticate_user!
	before_filter :get_data, :only => [:show]

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:user_id])
		@lo = Lo.find(params[:id])

		unless current_user.prof?
			unless current_user.team_ids.include?(@team.id)
				render_401
				return false
			end
			unless current_user.id == @user.id
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
		@exercises = @lo.exercises

    @team_stats = Hash.new
    @stats = Hash.new
    @exercises.each do |ex|
      @team_stats[ex.id] = Hash.new
      @stats[ex.id] = Hash.new
      ex.questions.each do |q|
        @team_stats[ex.id][q.id] = Statistic.find_or_create_by(:question_id => q.id, :team_id => @team.id)
        @stats[ex.id][q.id] = Statistic.find_or_create_by(:question_id => q.id, :team_id => nil)
      end
    end

    @last_answers = Answer.where(user_id:@user.id,team_id:@team.id,lo_id:@lo.id).desc(:updated_at)[0..5]

		Log.log_team_user_lo_view(current_user.id,@team.id,@user.id,@lo.id)

    @recent_activity_data = GraphDataGenerator::team_user_lo_recent_activity(@team.id,@user.id,@lo.id)
	end

  def overview
    @team = Team.find(params[:team_id])
    @lo = Lo.find(params[:id])
    @exercises = @lo.exercises

    if not current_user.admin? and @team.owner_id != current_user.id
      redirect_to panel_index_path
    end

    @team_stats = Hash.new
    @stats = Hash.new
    @exercises.each do |ex|
      @team_stats[ex.id] = Hash.new
      @stats[ex.id] = Hash.new
      ex.questions.each do |q|
        @team_stats[ex.id][q.id] = Statistic.find_or_create_by(:question_id => q.id, :team_id => @team.id)
        @stats[ex.id][q.id] = Statistic.find_or_create_by(:question_id => q.id, :team_id => nil)
      end
    end

		Log.log_team_lo_overview_view(current_user.id,@team.id,@lo.id)
  end
end
