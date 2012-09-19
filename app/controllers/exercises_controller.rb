class ExercisesController < ApplicationController
  respond_to :json
  before_filter :find_lo

  def index
    @exercises = @lo.exercises.order_by(:position => :desc)
  end

  def create
    @exercise = @lo.exercises.build(params[:exercise])
    if @exercise.save
      respond_with(@lo, @exercise)
    else
      respond_with(@lo, @exercise, status: 422)
    end
  end

  def show
    @exercise = @lo.exercises.find(params[:id])
    respond_with(@lo, @exercise)
  end

  def update
    @exercise = @lo.exercises.find(params[:id])

    if @exercise.update_attributes(params[:exercise])
      respond_with(@lo, @exercise)
    else
      respond_with(@lo, @exercise, status: 422)
    end
  end

  def destroy
    @exercise = @lo.exercises.find(params[:id])
    @exercise.destroy
    respond_with(@lo, @exercise)
  end

  def sort
    size = params[:ids].size
    params[:ids].each_with_index do |id, index|
      intro = @lo.exercises.find(id)
      intro.update_attribute(:position, size-index) if intro
    end
    render nothing: true
  end

private
 def find_lo
    if current_user.admin?
      @lo = Lo.find(params[:lo_id])
    else
      @lo = current_user.los.find(params[:lo_id])
    end
 end

end
