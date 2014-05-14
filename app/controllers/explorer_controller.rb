class ExplorerController < ApplicationController
	layout "explorer"
	before_filter :authenticate_user!

	def index
    @users = User.all	
    @teams = Team.all
    @los = Lo.all
    @questions = Question.all
	end

  def load_users
    @users = User.all
  end

  def search
    @as = Answer.search(params)
  end

  def fulltext_search
    @as = Answer.fulltext_search(params[:query])

    render 'search'
  end
end