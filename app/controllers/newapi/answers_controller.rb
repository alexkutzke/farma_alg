class Newapi::AnswersController < ApplicationController
	respond_to :json

	before_filter :authenticate_user!
  before_filter :verify_prof

	def show
		@answer = Answer.find(params[:id])
		unless current_user.admin?
			unless @answer.team.owner_id.to_s == current_user.id.to_s
				render_401
			end
		end
	end

  def connections
    @answer = Answer.find(params[:id])
    @connections = @answer.connections
		unless current_user.admin?
			unless @answer.team.owner_id.to_s == current_user.id.to_s
				render_401
			end
		end
  end

	def group_connections
		@connections = Connection.in(target_answer_id: params[:answer_ids]).in(answer_id:params[:answer_ids])

		render "connections"
	end

	def group
		if current_user.admin?
			@answers = Answer.find(params[:answer_ids])
		else
			@answers = Answer.find(params[:answer_ids]).where('team.owner_id' => current_user.id.to_s)
		end
	end

	def connected_component
		if current_user.admin?
			@answers = Answer.find(Answer.find(params[:id]).connected_component)
		else
			@answers = Answer.find(Answer.find(params[:id]).connected_component).where('team.owner_id' => current_user.id.to_s)
		end
		render "group"
	end

	def similar
		if current_user.admin?
			@answers = Answer.find(Answer.find(params[:id]).similar_answers)
		else
			@answers = Answer.find(Answer.find(params[:id]).similar_answers).where('team.owner_id' => current_user.id.to_s)
		end
		render "group"
	end

end
