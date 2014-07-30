class Dashboard::AnswersController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :can_view

  def can_view
    can = false
    @answer = Answer.find(params[:id])
    @answer.class_eval do
      attr_accessor :filter_names
    end

    @answer.filter_names = false

    if current_user.admin?
      can = true
    end

    if params.has_key?(:message_id)
      m = Message.find(params[:message_id])

      if m.target_user_ids.include?(current_user.id.to_s) and m.answer_ids.include?(params[:id])
        can = true

        @answer.filter_names = true
      end
    end

    if @answer.user_id == current_user.id
      can = true
    end

    if current_user.prof?
      if current_user.id.to_s == @answer.team.owner_id.to_s
        can = true
      end
    end
    

    unless can
      render :file => "public/401.html", :status => :unauthorized
    end
  end

  def show
    @available_tags = @answer.available_tags
    @answer.class_eval do
      attr_accessor :from_graph
    end

    if params.has_key?(:graph)
      @answer.from_graph = true
    else
      @answer.from_graph = false
    end
  end

end
