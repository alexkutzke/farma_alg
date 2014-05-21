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

  def info_answer
    @answer = Answer.find(params[:id])
  end

  def info_connection
    @connection = Connection.find(params[:id])
    @answer_a = Answer.find(@connection.answer_id)
    @answer_b = Answer.find(@connection.target_answer_id)
  end
end