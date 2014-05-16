class Newapi::AnswersController < ApplicationController
	respond_to :json

	before_filter :authenticate_user!

	def show
		@answer = Answer.find(params[:id])
	end

  def connections
    @answer = Answer.find(params[:id])
    @connections = @answer.connections
  end

end