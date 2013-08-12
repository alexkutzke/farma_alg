class AnswersPanelController < ApplicationController
	layout "answers_panel"
	before_filter :authenticate_user!

  def index
  	@answers = current_user.answers
  end
end
