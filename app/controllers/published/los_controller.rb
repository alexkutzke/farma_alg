class Published::LosController < ApplicationController

  def show
    if current_user.admin?
      @lo = Lo.find(params[:id])
    else
      @lo = current_user.los.find(params[:id])
    end
  end

end
