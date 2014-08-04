class Published::LosController < ApplicationController

  def show
    if current_user.admin?
      @lo = Lo.find(params[:id])
    else
      if params[:team_id]
        if current_user.prof?
          team = Team.find(params[:team_id])
          if team.owner_id != current_user.id
            render_401
          else
            @lo = Lo.find(params[:id])
          end
        else
          team = current_user.teams.find(params[:team_id])
          #if (team)
            @lo = team.los.find(params[:id])
          #end
        end
      else
        lo = Lo.find(params[:id])
        if lo.available
          @lo = lo
        else
          @lo = current_user.los.find(params[:id])
        end
      end
    end
  end

end
