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

end