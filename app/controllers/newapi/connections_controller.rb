class Newapi::ConnectionsController < ApplicationController
	respond_to :json

	before_filter :authenticate_user!

	def create
		a = Answer.find(params[:answer1_id])
		b = Answer.find(params[:answer2_id])

		@connection = SimilarityMachine::create_connection(a,b)
		@connection.weight = 1.0
		@connection.save!
	end

end