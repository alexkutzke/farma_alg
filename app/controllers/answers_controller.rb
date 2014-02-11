class AnswersController < ApplicationController
  include ActionView::Helpers::DateHelper 
  before_filter :authenticate_user!, except: :create
  respond_to :json
  before_filter :team_ids, only: :index

  def index
    if current_user.admin?
      @answers = Answer.search(params[:page], params[:search])
    else
      @answers = Answer.search(params[:page], params[:search], @team_ids)

      #@answers = Answer.in(team_id: @team_ids).entries
    end
  end

  def create
    last = LastAnswer.where(user_id: current_or_guest_user.id, question_id: params[:answer][:question_id]).try(:first)

#    if (last && last.answer && (last.answer.response == params[:answer][:response]))
#      @answer = last.answer
#    else
      @answer = current_or_guest_user.answers.create(params[:answer])
      @last_answers = Answer.where(user_id: current_or_guest_user.id, question_id: params[:answer][:question_id]).desc(:created_at)[0..4]
#    end

#    @answer.response = self.add_line_numbers @answer.response
  end

  def retroaction
    delete_retroaction_answers
    @answer = Answer.find(params[:id])
    @last_answers = Answer.where(user_id: current_or_guest_user.id, question_id: @answer.question_id).desc(:created_at)[0..4]
  end

  def team_ids
    owner_team_ids = Team.where(owner_id: current_user.id).map {|e| e.id}
    @team_ids ||= owner_team_ids | current_user.team_ids
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

private
  def delete_retroaction_answers
    retros = RetroactionAnswer.where(answer_id: params[:id], user_id: current_user.id)
    retros.delete_all
  end

end
