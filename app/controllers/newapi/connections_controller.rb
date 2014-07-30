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

		@connection = SimilarityMachine::create_connection(a,b)
		@connection.weight = 1.0
    @connection.confirmed = true
		@connection.save!

    Answer.propagate_properties_to_neigh(a,b.id)
    Answer.propagate_properties_to_neigh(b,a.id)
    a.schedule_process_propagate
    b.schedule_process_propagate
	end

  def accept_connection
		a = Answer.find(@connection.answer_id)
		b = Answer.find(@connection.target_answer_id)

		unless current_user.admin?
			unless a.team.owner_id.to_s == current_user.id.to_s
				unless b.team.owner_id.to_s == current_user.id.to_s
					render_401
				end
			end
		end

    @connection = Connection.find(params[:id])
    @connection.weight = 1.0
    @connection.confirmed = true
    @connection.save!

    Answer.propagate_properties_to_neigh(a,b.id)
    Answer.propagate_properties_to_neigh(b,a.id)

    a.schedule_process_propagate
    b.schedule_process_propagate
  end

  def reject_connection

    a = Answer.find(@connection.answer_id)
    b = Answer.find(@connection.target_answer_id)

		unless current_user.admin?
			unless a.team.owner_id.to_s == current_user.id.to_s
				unless b.team.owner_id.to_s == current_user.id.to_s
					render_401
				end
			end
		end


    @connection = Connection.find(params[:id])
    @connection2 = Connection.find_or_initialize_by(target_answer_id:@connection.answer_id, answer_id:@connection.target_answer_id)

    @connection.delete
    @connection2.delete

    @connections = [@connection,@connection2]

    aat_a = a.automatically_assigned_tags
    while not (i = aat_a.index{ |x| x[2].to_s == b.id.to_s }).nil?
      aat_a.delete_at(i)
    end

    aat_b = b.automatically_assigned_tags
    while not (i = aat_b.index{ |x| x[2].to_s == a.id.to_s }).nil?
      aat_b.delete_at(i)
    end

    a.save!
    b.save!
  end
end
