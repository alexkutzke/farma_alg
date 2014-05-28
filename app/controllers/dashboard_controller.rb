class DashboardController < ApplicationController
	layout "dashboard"

  before_filter :authenticate_user!

	def home
	end

  def graph
    @users = User.all
    @teams = Team.all
    @los = Lo.all
    @questions = Question.all
    @tags = Tag.all
  end

  def graph_search
    @as = Answer.search(params)
    
    render 'graph_search_result'
  end

  def timeline
    @users = User.all
    @teams = Team.all
    @los = Lo.all
    @questions = Question.all
    @tags = Tag.all
  end

  def timeline_search
    @as = Answer.search(params)

    render 'timeline_search_result'
  end

  def search
    @users = User.all
    @teams = Team.all
    @los = Lo.all
    @questions = Question.all
    @tags = Tag.all
  end

  def fulltext_search
    @as = Answer.search(params)

    render 'search_result'
  end
end