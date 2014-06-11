class Dashboard::AnswersController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :can_view

  def can_view
    can = false

    if current_user.admin?
      can = true
    end

    if params.has_key?(:message_id)
      m = Message.find(params[:message_id])

      if m.target_user_ids.include?(current_user.id.to_s) and m.answer_ids.include?(params[:id])
        can = true
      end 
    end
    unless can
      render :file => "public/401.html", :status => :unauthorized
    end
  end
  
  def show
    @answer = Answer.find(params[:id])
    @available_tags = @answer.available_tags
  end

end