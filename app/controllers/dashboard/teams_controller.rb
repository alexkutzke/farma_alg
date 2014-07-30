class Dashboard::TeamsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin, :only =>[:new, :update, :edit, :create,:destroy]
  before_filter :can_edit?, :only =>[:update, :edit, :destroy]

  layout "dashboard"

  def can_edit?
    unless current_user.lo_ids.include?(params[:id]) || current_user.admin?
      render :file => "public/401.html", :status => :unauthorized
    end
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])
    @team.owner_id = current_user.id
    respond_to do |format|
      if @team.save
        format.html { redirect_to dashboard_teams_available_path, notice: 'Turma criada com sucesso.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to panel_team_path(@team.id), notice: 'Turma atualizada com sucesso.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def enroll
    t = Team.find(params[:team][:id])
    unless t.users.include?(current_user)
      if t.code == params[:password]
        t.users << current_user
        t.save!
      else
        @wrong_code_team_id = t.id
      end
    end
    @teams = Team.all

    redirect_to dashboard_teams_available_path
  end

  def unenroll
    @team = Team.find(params[:id])

    if @team.users.include?(current_user)
      @team.user_ids = @team.user_ids - [current_user.id]
      @team.save!
    end

    redirect_to dashboard_teams_available_path
  end

  def destroy
    @team = Team.find(params[:id])

    if @team.owner_id == current_user.id
      @team.destroy
    end

    redirect_to dashboard_teams_available_path
  end

  def available
    @teams = Team.all
  end

end
