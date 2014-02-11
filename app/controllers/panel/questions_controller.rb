class Panel::QuestionsController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!
	before_filter :get_data

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:user_id])
		@lo = Lo.find(params[:lo_id])
		@question = Question.find(params[:id])
	end

	def show
		@answers = Answer.where(user_id: @user.id, team_id: @team.id, question_id:@question.id).desc(:created_at)
	end
end