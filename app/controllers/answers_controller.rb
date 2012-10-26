class AnswersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json
  before_filter :team_ids, only: :index

  def index
    if params[:search]
      @answers = Answer.where(params[:search]).in(team_id: @team_ids).page(params[:page]).per(20)
    else
      @answers = Answer.where(:team_id.in => @team_ids).page(params[:page]).per(20)
    end
  end

  def create
    last = LastAnswer.where(user_id: current_user.id, question_id: params[:answer][:question_id]).try(:first)

    if (last && last.answer && (last.answer.response == params[:answer][:response]))
      @answer = last.answer
    else
      @answer = current_user.answers.create(params[:answer])
    end
  end

  def retroaction
    @answer = Answer.find(params[:id])
  end

  def team_ids
    owner_team_ids = Team.where(owner_id: current_user.id).map {|e| e.id}
    @team_ids ||= owner_team_ids | current_user.team_ids
  end

end
