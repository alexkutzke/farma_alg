class Panel::LosController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!
	before_filter :get_data, :only => [:show]

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:user_id])
		@lo = Lo.find(params[:id])
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
  end
end