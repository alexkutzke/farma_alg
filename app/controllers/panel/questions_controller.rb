class Panel::QuestionsController < ApplicationController
	layout "dashboard"
	before_filter :authenticate_user!
	before_filter :get_data

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:user_id])
		@lo = Lo.find(params[:lo_id])
		@question = Question.find(params[:id])

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
		@answers = Answer.where(user_id: @user.id, team_id: @team.id, question_id:@question.id).desc(:created_at)
		Log.log_team_user_lo_question_view(current_user.id,@team.id,@user.id,@lo.id,@question.id)
	end
end
