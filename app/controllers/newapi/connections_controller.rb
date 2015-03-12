class Newapi::ConnectionsController < ApplicationController
	respond_to :json

	before_filter :authenticate_user!
  before_filter :verify_prof

  def create
		a = Answer.find(params[:answer1_id])
		b = Answer.find(params[:answer2_id])

		unless current_user.admin?
			unless a.team.owner_id.to_s == current_user.id.to_s
				unless b.team.owner_id.to_s == current_user.id.to_s
					render_401
				end
			end
		end

		@connection = SimilarityMachine::create_connection(a,b,true)
		@connection.weight = 1.0
    @connection.confirmed = true
		@connection.save!

    Answer.propagate_properties_to_neigh(a,b.id)
    Answer.propagate_properties_to_neigh(b,a.id)
    a.schedule_process_propagate
    b.schedule_process_propagate

		Log.log_connection_create(current_user.id,@connection.id)
	end

  def accept_connection
		@connection = Connection.find(params[:id])

		a = Answer.find(@connection.answer_id)
		b = Answer.find(@connection.target_answer_id)

		unless current_user.admin?
			unless a.team.owner_id.to_s == current_user.id.to_s
				unless b.team.owner_id.to_s == current_user.id.to_s
					render_401
				end
			end
		end


    @connection.weight = 1.0
    @connection.confirmed = true
    @connection.save!

    Answer.propagate_properties_to_neigh(a,b.id)
    Answer.propagate_properties_to_neigh(b,a.id)

    a.schedule_process_propagate
    b.schedule_process_propagate

		Log.log_connection_accept(current_user.id,@connection.id)
  end

  def reject_connection
    @connection = Connection.find(params[:id])
    @connection2 = Connection.find_or_initialize_by(target_answer_id:@connection.answer_id, answer_id:@connection.target_answer_id)

    a = Answer.find(@connection.answer_id)
    b = Answer.find(@connection.target_answer_id)

		unless current_user.admin?
			unless a.team.owner_id.to_s == current_user.id.to_s
				unless b.team.owner_id.to_s == current_user.id.to_s
					render_401
				end
			end
		end

		@connections = [@connection,@connection2]

    @connection.delete
    @connection2.delete

    aat_a = a.automatically_assigned_tags
    while not (i = aat_a.index{ |x| x[2].to_s == b.id.to_s }).nil?
      aat_a.delete_at(i)
    end

    aat_b = b.automatically_assigned_tags
    while not (i = aat_b.index{ |x| x[2].to_s == a.id.to_s }).nil?
      aat_b.delete_at(i)
    end

		Log.log_connection_reject(current_user.id,{answer_1_id:a.id,answer2_id:b.id})

    a.save!
    b.save!
  end
end
