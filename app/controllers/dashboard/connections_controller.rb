class Dashboard::ConnectionsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :can_view


  def can_view
    @connection = Connection.find(params[:id])
    @answer1 = Answer.find(@connection.answer_id)
    @answer2 = Answer.find(@connection.target_answer_id)

    can = false

    if current_user.admin?
      can = true
    end

    if @answer1.user_id == current_user.id && @answer2.user_id == current_user.id
      can = true
    end

    unless can
      render :file => "public/401.html", :status => :unauthorized
    end
  end

  def show
  end
end
