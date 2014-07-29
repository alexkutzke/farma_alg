class Newapi::AnswersController < ApplicationController
	respond_to :json

	before_filter :authenticate_user!
  before_filter :verify_admin

  def verify_admin
    unless current_user.admin?
      render :file => "public/401.html", :status => :unauthorized
    end
  end

	def show
		@answer = Answer.find(params[:id])
	end

  def connections
    @answer = Answer.find(params[:id])
    @connections = @answer.connections
  end

	def group_connections
		@connections = Connection.in(target_answer_id: params[:answer_ids]).in(answer_id:params[:answer_ids])
		render "connections"
	end

	def group
		@answers = Answer.find(params[:answer_ids])
	end

	def connected_component
		@answers = Answer.find(Answer.find(params[:id]).connected_component)
		render "group"
	end

	def similar
		@answers = Answer.find(Answer.find(params[:id]).similar_answers)
		render "group"
	end

end
