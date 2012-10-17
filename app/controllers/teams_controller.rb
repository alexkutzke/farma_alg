class TeamsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!
  before_filter :teams, except: :enrolled

  def index
    @teams = Team.all.desc(:created_at).page(params[:page]).per(10)
  end

  def enrolled
    @teams = current_user.teams
  end

  def created
    @teams = @owner_teams.desc(:created_at)
  end

  def enroll
    @team = Team.find(params[:id])
    if @team.enroll(current_user, params[:code])
      respond_with(@team)
    else
      respond_with(@team, status: 422)
    end
  end

  def show
    @team = @owner_teams.find(params[:id])
    respond_with(@team)
  end

  def create
    @team = Team.new(params[:team])
    @team.owner_id = current_user.id

    if @team.save
      respond_with(@team)
    else
      respond_with(@team, status: 422)
    end
  end

  def update
    @team = @owner_teams.find(params[:id])

    if @team.update_attributes(params[:team])
      respond_with(@team)
    else
      respond_with(@team, status: 422)
    end
  end

  def destroy
    @team = @owner_teams.find(params[:id])
    @team.destroy
    respond_with(@team)
  end

private
  def teams
    if current_user.admin?
      @owner_teams = Team.all
    else
      @owner_teams = Team.where(owner_id: current_user.id)
    end
  end

end
