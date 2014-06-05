class Dashboard::AnswersController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def verify_admin
    unless current_user.admin?
      render :file => "public/401.html", :status => :unauthorized
    end
  end
  
  def show
    @answer = Answer.find(params[:id])
    @available_tags = @answer.available_tags
  end

end