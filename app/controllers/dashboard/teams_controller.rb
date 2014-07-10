class Dashboard::TeamsController < ApplicationController
  before_filter :authenticate_user!
  layout "dashboard"

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

    render "available"
  end

  def available
    @teams = Team.all
  end

end