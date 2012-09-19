class LosController < ApplicationController
  respond_to :json

  def index
    if current_user.admin?
      @los = Lo.all.order_by(:created_at => :desc)
    else
      @los = current_user.los.order_by(:created_at => :desc)
    end
  end

  def show
    if current_user.admin?
      respond_with Lo.find(params[:id])
    else
      respond_with current_user.los.find(params[:id])
    end
  end

  def create
    respond_with current_user.los.create(params[:lo])
  end

  def update
    if current_user.admin?
      @lo = Lo.find(params[:id])
    else
      @lo = current_user.los.find(params[:id])
    end

    if  @lo.update_attributes(params[:lo])
      respond_with(@lo)
    else
      respond_with(@lo, status: 402)
    end
  end

  def destroy
    if current_user.admin?
      respond_with current_user.los.find(params[:id]).destroy
    else
      respond_with Lo.find(params[:id]).destroy
    end
  end

end
