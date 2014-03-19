class TeamsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!
  before_filter :teams, except: :enrolled

  def index
    @teams = Team.search(params[:search]).page(params[:page]).per(10).asc('name')
    #p @teams
  end

  def enrolled
    @teams = current_user.teams
  end

  def created
    @teams = @owner_teams.asc(:name)
  end

  def my_teams
    @teams = created | enrolled
  end

  def learners
    if params[:team_id]
      @learners = Team.find(params[:team_id]).users
    else
      @learners = []
      @owner_teams.each {|team| @learners = @learners | team.users}
    end
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
    #@team = @owner_teams.find(params[:id])
    @team = Team.find(params[:id])
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

  def teams_for_search
    if current_user.admin?
      @teams = Team.desc(:created_at)
    else
      my_teams
    end
  end

private
  def teams
    if current_user.super_admin?
      @owner_teams = Team.all
    else
      @owner_teams = Team.where(owner_id: current_user.id)
    end
  end

end
