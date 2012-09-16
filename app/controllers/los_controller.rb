class LosController < ApplicationController
  respond_to :json

  def index
    @los = Lo.all.order_by(:created_at => :desc)
  end

  def show
    respond_with Lo.find(params[:id])
  end

  def create
    respond_with Lo.create(params[:lo])
  end

  def update
    @lo =  Lo.find(params[:id])

    if  @lo.update_attributes(params[:lo])
      respond_with(@lo)
    else
      respond_with(@lo, status: 402)
    end
  end

  def destroy
    respond_with Lo.find(params[:id]).destroy
  end
end
