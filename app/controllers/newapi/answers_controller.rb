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
			@answers = Answer.in(_id:params[:answer_ids]).where('team.owner_id' => current_user.id)
		end
	end

	def connected_component
		if current_user.admin?
			@answers = Answer.find(Answer.find(params[:id]).connected_component)
		else
			@answers = Answer.in(_id: Answer.find(params[:id]).connected_component).where('team.owner_id' => current_user.id)
		end
		render "group"
	end

	def similar
		answer = Answer.find(params[:id])
		ids = [answer.id] + answer.similar_answers

		if current_user.admin?
			@answers = Answer.find(ids)
		else
			@answers = Answer.in(_id: ids).where('team.owner_id' => current_user.id)
		end
		render "group"
	end

end
