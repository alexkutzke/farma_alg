class Newapi::ConnectionsController < ApplicationController
	respond_to :json

	before_filter :authenticate_user!

	def create
		a = Answer.find(params[:answer1_id])
		b = Answer.find(params[:answer2_id])

		@connection = SimilarityMachine::create_connection(a,b)
		@connection.weight = 1.0
    @connection.confirmed = true
		@connection.save!
	end

  def accept_connection
    @connection = Connection.find(params[:id])
    @connection.weight = 1.0
    @connection.confirmed = true
    @connection.save!
  end

  def reject_connection
    @connection = Connection.find(params[:id])
    @connection2 = Connection.find_or_initialize_by(target_answer_id:@connection.answer_id, answer_id:@connection.target_answer_id)

    @connection.delete
    @connection2.delete

    @connections = [@connection,@connection2]
  end
end