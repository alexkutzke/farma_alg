class AnswersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    last = LastAnswer.where(user_id: current_user.id, question_id: params[:answer][:question_id]).try(:first)

    if (last && (last.answer.response == params[:answer][:response]))
      @answer = last.answer
    else
      @answer = current_user.answers.create(params[:answer])
    end
  end

end
