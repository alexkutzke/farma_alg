class Dashboard::ConnectionsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def verify_admin
    unless current_user.admin?
      render :file => "public/401.html", :status => :unauthorized
    end
  end
  
  def show
    @connection = Connection.find(params[:id])
    @answer1 = Answer.find(@connection.answer_id)
    @answer2 = Answer.find(@connection.target_answer_id)
  end
end