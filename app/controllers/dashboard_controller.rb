class DashboardController < ApplicationController
	layout "dashboard"

  before_filter :authenticate_user!

  def init_search
    @teams = current_user.all_teams
    @questions = current_user.all_questions
    @los = current_user.all_los
    @users = current_user.all_students
    @tags = current_user.all_tags
  end

	def home
	end

  def graph
    init_search
  end

  def graph_search
    @as = Answer.search(params,current_user)
    
    render 'graph_search_result'
  end

  def timeline
    init_search
  end

  def timeline_search
    @as = Answer.search(params)

    render 'timeline_search_result'
  end

  def search
    init_search
  end

  def fulltext_search
    @as = Answer.search(params,current_user)

    render 'search_result'
  end
end