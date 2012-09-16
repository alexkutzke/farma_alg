class QuestionsController < ApplicationController
  respond_to :json
  before_filter :find_exercise

  def index
    @questions = @exercise.questions.order_by(:position => :desc)
  end

  def create
    @question = @exercise.questions.build(params[:question])
    if @question.save
      respond_with(@lo, @exercise, @question)
    else
      respond_with(@lo, @exercise, @question, status: 422)
    end
  end

  def show
    @question = @exercise.questions.find(params[:id])
    respond_with(@lo, @exercise, @question)
  end

  def update
    @question = @exercise.questions.find(params[:id])

    if @question.update_attributes(params[:question])
      respond_with(@lo, @exercise, @question)
    else
      respond_with(@lo, @exercise, @question, status: 422)
    end
  end

  def destroy
    @question = @exercise.questions.find(params[:id])
    @question.destroy
    respond_with(@lo, @exercise, @question)
  end

  def sort
    size = params[:ids].size
    params[:ids].each_with_index do |id, index|
      q = Question.find(id)
      q.update_attribute(:position, size-index) if q
    end
    render nothing: true
  end

private
 def find_exercise
   @lo = Lo.find(params[:lo_id])
   @exercise = Exercise.find(params[:exercise_id])
 end

end
