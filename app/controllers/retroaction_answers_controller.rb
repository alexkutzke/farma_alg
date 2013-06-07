class RetroactionAnswersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    @retroaction = RetroactionAnswer.where(answer_id: params[:retroaction_answer][:answer_id],
                                           question_id: params[:retroaction_answer][:question_id],
                                           user_id: current_user.id).try(:first)

    if @retroaction
      @retroaction.response= params[:retroaction_answer][:response]
      @retroaction.save
    else
      @retroaction = current_user.retroaction_answers.create(params[:retroaction_answer])
    end

    @retroaction.response = add_line_numbers @retroaction.response
  end

  def add_line_numbers(x)
    i = 1
    new_response = ""
    x.lines.each do |l|
      new_response = new_response + "%02d" % i + "  " + l
      i = i + 1
    end
    new_response
  end

end
