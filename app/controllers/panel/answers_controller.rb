class Panel::AnswersController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!
	before_filter :get_data

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:user_id])
		@lo = Lo.find(params[:lo_id])
		@question = Question.find(params[:question_id])
		@answer = Answer.find(params[:id])
	end

	def show
		@previous_answers = Answer.where(user_id: @user.id, team_id: @team.id, question_id: @question.id).desc(:created_at).lt(created_at: @answer.created_at)[0..4]

		@previous_answers.each do |p|
			a = Answer.where(user_id: @user.id, team_id: @team.id, question_id: @question.id).desc(:created_at).lt(created_at: p.created_at).first
			unless a.nil?
				p['previous'] = a.response
			end
		end
	end
end