class PanelController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!

	def index
		@my_teams = Team.where(owner_id: current_user.id).asc('name')
		@teams = current_user.teams.asc('name')
    @others = Array.new
    if current_user.admin?
      @others = Team.all.asc('name').entries - @my_teams
		end
    @last_comments = Comment.where(target_user_id: current_user.id).desc('created_at')[0..4]
    #@old_teams = Answer.all.distinct('team_id') - Team.all.entries
	end

  def comments
    @comments = Comment.where(target_user_id:current_user.id).desc('created_at')
  end
end